-- ============================================================================
-- FILE: procedures_v2.sql
-- PURPOSE: Additional stored procedures for:
--          - Admin authentication (Super Admin / Template Manager)
--          - Reliability_Config management (Super Admin)
--          - Proposal_Template CRUD (Template Manager)
--          - Skills lookups (Freelancer & Job)
--          - Job / Template detail views (clickable rows)
--          - Client reliability + dynamic recommendation (for proposal form)
-- Run AFTER schema_updates.sql
-- ============================================================================

USE upworkproposalgenerator;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- 1. sp_login_admin
--    Authenticates an admin and classifies them as super_admin / template_manager
--    based on their Admin.role value.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_login_admin$$
CREATE PROCEDURE sp_login_admin(
    IN p_email    VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT
        p.person_id AS admin_id,
        p.f_name,
        p.Lname,
        p.email,
        a.role,
        CASE
            WHEN a.role = 'User Account Analysis' THEN 'super_admin'
            WHEN a.role = 'Proposal Handling'      THEN 'template_manager'
            ELSE 'admin'
        END AS admin_type
    FROM Person p
    INNER JOIN Admin a ON a.admin_id = p.person_id
    WHERE p.email    = p_email
      AND a.password = p_password
    LIMIT 1;
END$$


-- ----------------------------------------------------------------------------
-- 2. sp_get_reliability_config
--    Returns the single Reliability_Config row (Super Admin only).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_reliability_config$$
CREATE PROCEDURE sp_get_reliability_config()
BEGIN
    SELECT * FROM Reliability_Config WHERE config_id = 1;
END$$


-- ----------------------------------------------------------------------------
-- 3. sp_update_reliability_config
--    Updates scoring weights and recommendation thresholds (Super Admin only).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_update_reliability_config$$
CREATE PROCEDURE sp_update_reliability_config(
    IN p_weight_jsr       DECIMAL(5,2),
    IN p_weight_reviews   DECIMAL(5,2),
    IN p_weight_payment   DECIMAL(5,2),
    IN p_threshold_strong DECIMAL(5,2),
    IN p_threshold_apply  DECIMAL(5,2),
    IN p_threshold_consider DECIMAL(5,2)
)
BEGIN
    UPDATE Reliability_Config
    SET weight_jsr             = p_weight_jsr,
        weight_reviews         = p_weight_reviews,
        weight_payment         = p_weight_payment,
        threshold_strong_apply = p_threshold_strong,
        threshold_apply        = p_threshold_apply,
        threshold_consider     = p_threshold_consider
    WHERE config_id = 1;

    SELECT * FROM Reliability_Config WHERE config_id = 1;
END$$


-- ----------------------------------------------------------------------------
-- 4. sp_get_reliability_scores  (OVERRIDE)
--    Now computes recommendation_level DYNAMICALLY based on
--    Reliability_Config thresholds, instead of the static seeded value.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_reliability_scores$$
CREATE PROCEDURE sp_get_reliability_scores()
BEGIN
    SELECT
        rs.score_id,
        rs.client_id,
        c.company_name,
        rs.score,
        rs.risk_level,
        CASE
            WHEN rs.score >= rc.threshold_strong_apply THEN 'Strong Apply'
            WHEN rs.score >= rc.threshold_apply        THEN 'Apply'
            WHEN rs.score >= rc.threshold_consider     THEN 'Consider'
            ELSE 'Skip'
        END AS recommendation_level,
        rs.calculated_date
    FROM Reliability_Score rs
    INNER JOIN Client c             ON c.client_id  = rs.client_id
    CROSS JOIN Reliability_Config rc ON rc.config_id = 1
    ORDER BY rs.score DESC;
END$$


-- ----------------------------------------------------------------------------
-- 5. sp_get_client_reliability
--    Returns score + dynamic recommendation for ONE client.
--    Used in the Create Proposal form so the freelancer sees a live
--    "Apply / Strong Apply / Consider / Skip" recommendation.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_client_reliability$$
CREATE PROCEDURE sp_get_client_reliability(
    IN p_client_id INT
)
BEGIN
    SELECT
        rs.client_id,
        rs.score,
        rs.risk_level,
        CASE
            WHEN rs.score >= rc.threshold_strong_apply THEN 'Strong Apply'
            WHEN rs.score >= rc.threshold_apply        THEN 'Apply'
            WHEN rs.score >= rc.threshold_consider     THEN 'Consider'
            ELSE 'Skip'
        END AS recommendation_level
    FROM Reliability_Score rs
    CROSS JOIN Reliability_Config rc ON rc.config_id = 1
    WHERE rs.client_id = p_client_id
    ORDER BY rs.calculated_date DESC
    LIMIT 1;
END$$


-- ----------------------------------------------------------------------------
-- 6. sp_create_template  (Template Manager only)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_create_template$$
CREATE PROCEDURE sp_create_template(
    IN p_admin_id        INT,
    IN p_template_name   VARCHAR(100),
    IN p_category        VARCHAR(60),
    IN p_template_content TEXT
)
BEGIN
    DECLARE v_new_id INT;
    SELECT COALESCE(MAX(template_id), 0) + 1 INTO v_new_id FROM Proposal_Template;

    INSERT INTO Proposal_Template (
        template_id, admin_id, template_name, category, template_content, usage_count, success_rate
    ) VALUES (
        v_new_id, p_admin_id, p_template_name, p_category, p_template_content, 0, 0.00
    );

    SELECT v_new_id AS template_id;
END$$


-- ----------------------------------------------------------------------------
-- 7. sp_update_template  (Template Manager only)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_update_template$$
CREATE PROCEDURE sp_update_template(
    IN p_template_id     INT,
    IN p_template_name   VARCHAR(100),
    IN p_category        VARCHAR(60),
    IN p_template_content TEXT
)
BEGIN
    UPDATE Proposal_Template
    SET template_name    = p_template_name,
        category         = p_category,
        template_content = p_template_content
    WHERE template_id = p_template_id;

    SELECT ROW_COUNT() AS rows_affected;
END$$


-- ----------------------------------------------------------------------------
-- 8. sp_delete_template  (Template Manager only)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_delete_template$$
CREATE PROCEDURE sp_delete_template(
    IN p_template_id INT
)
BEGIN
    DELETE FROM Proposal_Template WHERE template_id = p_template_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$


-- ----------------------------------------------------------------------------
-- 9. sp_get_templates_admin  (Template Manager view — includes template_content)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_templates_admin$$
CREATE PROCEDURE sp_get_templates_admin()
BEGIN
    SELECT
        template_id, admin_id, template_name, category,
        template_content, usage_count, success_rate
    FROM Proposal_Template
    ORDER BY template_id;
END$$


-- ----------------------------------------------------------------------------
-- 10. sp_get_freelancer_skills
--     Returns the skills mapped to a freelancer via Freelancer_Skill_Map.
--     New signups will simply have no rows here (NULL/empty result).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_freelancer_skills$$
CREATE PROCEDURE sp_get_freelancer_skills(
    IN p_freelancer_id INT
)
BEGIN
    SELECT s.skill_id, s.skill_name, s.skill_level
    FROM Freelancer_Skill_Map fsm
    INNER JOIN Skills s ON s.skill_id = fsm.skill_id
    WHERE fsm.freelancer_id = p_freelancer_id;
END$$


-- ----------------------------------------------------------------------------
-- 11. sp_get_job_skills
--     Returns the skills required for a job via Job_Skill_Map.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_job_skills$$
CREATE PROCEDURE sp_get_job_skills(
    IN p_job_id INT
)
BEGIN
    SELECT s.skill_id, s.skill_name, s.skill_level
    FROM Job_Skill_Map jsm
    INNER JOIN Skills s ON s.skill_id = jsm.skill_id
    WHERE jsm.job_id = p_job_id;
END$$


-- ----------------------------------------------------------------------------
-- 12. sp_get_job_details
--     Full detail view of a single job (for clickable rows in My Proposals).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_job_details$$
CREATE PROCEDURE sp_get_job_details(
    IN p_job_id INT
)
BEGIN
    SELECT
        jp.job_id, jp.job_title, jp.job_description, jp.experience_level,
        jp.job_type, jp.project_duration, jp.budget_amount, jp.posted_date,
        jp.proposal_count, c.company_name, jp.client_id
    FROM Job_Posting jp
    INNER JOIN Client c ON c.client_id = jp.client_id
    WHERE jp.job_id = p_job_id;
END$$


-- ----------------------------------------------------------------------------
-- 13. sp_get_template_details
--     Full detail view of a single template (for clickable rows in My Proposals).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_template_details$$
CREATE PROCEDURE sp_get_template_details(
    IN p_template_id INT
)
BEGIN
    SELECT
        template_id, template_name, category,
        template_content, usage_count, success_rate
    FROM Proposal_Template
    WHERE template_id = p_template_id;
END$$


-- ----------------------------------------------------------------------------
-- 14. sp_get_jobs_by_client
--     Returns only the jobs posted by a specific client.
--     Used to populate the Job dropdown after a Client is selected
--     on the Create Proposal form.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_jobs_by_client$$
CREATE PROCEDURE sp_get_jobs_by_client(
    IN p_client_id INT
)
BEGIN
    SELECT job_id, job_title, experience_level, job_type, budget_amount, posted_date
    FROM Job_Posting
    WHERE client_id = p_client_id
    ORDER BY posted_date DESC;
END$$


-- ----------------------------------------------------------------------------
-- 15. sp_get_proposals  (OVERRIDE)
--     Now also returns the client's reliability score and a dynamically
--     computed recommendation (Strong Apply / Apply / Consider / Skip)
--     based on Reliability_Config thresholds, for the "should I apply?"
--     guidance feature.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_proposals$$
CREATE PROCEDURE sp_get_proposals(
    IN p_freelancer_id INT
)
BEGIN
    SELECT
        gp.proposal_id,
        gp.client_id,
        gp.job_id,
        gp.template_id,
        gp.proposal_content,
        gp.generated_date,
        gp.proposal_status,
        gp.submission_date,
        jp.job_title,
        pt.template_name,
        c.company_name,
        rs.score AS client_score,
        CASE
            WHEN rs.score IS NULL THEN 'Unknown'
            WHEN rs.score >= rc.threshold_strong_apply THEN 'Strong Apply'
            WHEN rs.score >= rc.threshold_apply        THEN 'Apply'
            WHEN rs.score >= rc.threshold_consider     THEN 'Consider'
            ELSE 'Skip'
        END AS recommendation_level
    FROM Generated_Proposals gp
    INNER JOIN Job_Posting jp        ON jp.job_id       = gp.job_id
    INNER JOIN Proposal_Template pt  ON pt.template_id  = gp.template_id
    INNER JOIN Client c              ON c.client_id     = gp.client_id
    LEFT JOIN Reliability_Score rs   ON rs.client_id    = gp.client_id
    CROSS JOIN Reliability_Config rc ON rc.config_id    = 1
    WHERE gp.freelancer_id = p_freelancer_id
    ORDER BY gp.generated_date DESC;
END$$

DELIMITER ;
