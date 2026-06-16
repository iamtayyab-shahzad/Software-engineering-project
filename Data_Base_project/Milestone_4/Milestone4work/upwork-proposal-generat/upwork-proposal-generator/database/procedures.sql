-- ============================================================================
-- FILE: procedures.sql
-- PURPOSE: All stored procedures for Upwork Proposal Generator
-- USE DATABASE FIRST: USE upworkproposalgenerator;
-- ============================================================================

USE upworkproposalgenerator;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- 1. sp_signup_freelancer
--    Inserts into Person then Freelancer. Assigns next available person_id.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_signup_freelancer$$
CREATE PROCEDURE sp_signup_freelancer(
    IN p_f_name      VARCHAR(50),
    IN p_lname       VARCHAR(50),
    IN p_email       VARCHAR(100),
    IN p_password    VARCHAR(255)
)
BEGIN
    DECLARE v_new_id INT;
    DECLARE v_analytics_id INT;
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Derive next person_id
    SELECT COALESCE(MAX(person_id), 0) + 1 INTO v_new_id FROM Person;

    -- Insert into Person master table
    INSERT INTO Person (person_id, f_name, Lname, email, country, upwork_profile_url)
    VALUES (v_new_id, p_f_name, p_lname, p_email, NULL, NULL);

    -- Insert into Freelancer subtype
    INSERT INTO Freelancer (freelancer_id, password, hourly_rate, experience_years)
    VALUES (v_new_id, p_password, NULL, NULL);

    -- Seed a Freelancer_Analytics row so dashboard always has a record
    SELECT COALESCE(MAX(analytics_id), 0) + 1 INTO v_analytics_id FROM Freelancer_Analytics;
    INSERT INTO Freelancer_Analytics (analytics_id, freelancer_id, total_proposals, accepted_proposals, rejected_proposals, success_rate)
    VALUES (v_analytics_id, v_new_id, 0, 0, 0, 0.00);

    COMMIT;

    -- Return the new freelancer's id and name for session use
    SELECT v_new_id AS freelancer_id, p_f_name AS f_name, p_lname AS lname, p_email AS email;
END$$

-- ----------------------------------------------------------------------------
-- 2. sp_login_freelancer
--    Returns freelancer row if email + password match; empty set = bad creds.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_login_freelancer$$
CREATE PROCEDURE sp_login_freelancer(
    IN p_email    VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT
        p.person_id   AS freelancer_id,
        p.f_name,
        p.Lname,
        p.email
    FROM Person p
    INNER JOIN Freelancer f ON f.freelancer_id = p.person_id
    WHERE p.email       = p_email
      AND f.password    = p_password
    LIMIT 1;
END$$

-- ----------------------------------------------------------------------------
-- 3. sp_get_dashboard_stats
--    Returns the four KPI cards for the logged-in freelancer.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_dashboard_stats$$
CREATE PROCEDURE sp_get_dashboard_stats(
    IN p_freelancer_id INT
)
BEGIN
    SELECT
        fa.total_proposals,
        fa.accepted_proposals,
        fa.rejected_proposals,
        fa.success_rate
    FROM Freelancer_Analytics fa
    WHERE fa.freelancer_id = p_freelancer_id
    LIMIT 1;
END$$

-- ----------------------------------------------------------------------------
-- 4. sp_get_templates
--    Returns all Proposal_Template rows (read-only view for freelancer).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_templates$$
CREATE PROCEDURE sp_get_templates()
BEGIN
    SELECT
        template_id,
        template_name,
        category,
        usage_count,
        success_rate
    FROM Proposal_Template
    ORDER BY template_id;
END$$

-- ----------------------------------------------------------------------------
-- 5. sp_get_jobs
--    Returns all Job_Posting rows (read-only view for freelancer).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_jobs$$
CREATE PROCEDURE sp_get_jobs()
BEGIN
    SELECT
        jp.job_id,
        jp.job_title,
        jp.experience_level,
        jp.job_type,
        jp.budget_amount,
        jp.posted_date,
        jp.project_duration
    FROM Job_Posting jp
    ORDER BY jp.posted_date DESC;
END$$

-- ----------------------------------------------------------------------------
-- 6. sp_get_reliability_scores
--    Returns all Reliability_Score rows joined with Client company name.
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
        rs.recommendation_level,
        rs.calculated_date
    FROM Reliability_Score rs
    INNER JOIN Client c ON c.client_id = rs.client_id
    ORDER BY rs.score DESC;
END$$

-- ----------------------------------------------------------------------------
-- 7. sp_get_proposals
--    Returns all Generated_Proposals for a specific freelancer.
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
        pt.template_name
    FROM Generated_Proposals gp
    INNER JOIN Job_Posting jp        ON jp.job_id       = gp.job_id
    INNER JOIN Proposal_Template pt  ON pt.template_id  = gp.template_id
    WHERE gp.freelancer_id = p_freelancer_id
    ORDER BY gp.generated_date DESC;
END$$

-- ----------------------------------------------------------------------------
-- 8. sp_create_proposal
--    Inserts a new Generated_Proposals row.
--    The AFTER INSERT trigger on Generated_Proposals will update analytics.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_create_proposal$$
CREATE PROCEDURE sp_create_proposal(
    IN p_freelancer_id    INT,
    IN p_client_id        INT,
    IN p_job_id           INT,
    IN p_template_id      INT,
    IN p_proposal_content TEXT,
    IN p_proposal_status  VARCHAR(20),
    IN p_submission_date  DATE
)
BEGIN
    DECLARE v_new_id INT;

    SELECT COALESCE(MAX(proposal_id), 0) + 1 INTO v_new_id FROM Generated_Proposals;

    INSERT INTO Generated_Proposals (
        proposal_id, freelancer_id, client_id, job_id, template_id,
        proposal_content, generated_date, proposal_status, submission_date
    ) VALUES (
        v_new_id, p_freelancer_id, p_client_id, p_job_id, p_template_id,
        p_proposal_content, NOW(), p_proposal_status, p_submission_date
    );

    -- Also increment usage_count on the chosen template
    UPDATE Proposal_Template
    SET usage_count = usage_count + 1
    WHERE template_id = p_template_id;

    SELECT v_new_id AS proposal_id;
END$$

-- ----------------------------------------------------------------------------
-- 9. sp_update_proposal
--    Updates proposal_content, proposal_status, and submission_date.
--    Analytics recalc is handled by the AFTER UPDATE trigger.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_update_proposal$$
CREATE PROCEDURE sp_update_proposal(
    IN p_proposal_id      INT,
    IN p_freelancer_id    INT,
    IN p_proposal_content TEXT,
    IN p_proposal_status  VARCHAR(20),
    IN p_submission_date  DATE
)
BEGIN
    UPDATE Generated_Proposals
    SET proposal_content  = p_proposal_content,
        proposal_status   = p_proposal_status,
        submission_date   = p_submission_date
    WHERE proposal_id   = p_proposal_id
      AND freelancer_id = p_freelancer_id;

    SELECT ROW_COUNT() AS rows_affected;
END$$

-- ----------------------------------------------------------------------------
-- 10. sp_delete_proposal
--     Deletes a proposal owned by the given freelancer.
--     The AFTER DELETE trigger recalculates analytics.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_delete_proposal$$
CREATE PROCEDURE sp_delete_proposal(
    IN p_proposal_id   INT,
    IN p_freelancer_id INT
)
BEGIN
    DELETE FROM Generated_Proposals
    WHERE proposal_id   = p_proposal_id
      AND freelancer_id = p_freelancer_id;

    SELECT ROW_COUNT() AS rows_affected;
END$$

-- ----------------------------------------------------------------------------
-- 11. sp_get_clients  (helper for Create-Proposal form dropdown)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_clients$$
CREATE PROCEDURE sp_get_clients()
BEGIN
    SELECT
        c.client_id,
        c.company_name,
        p.f_name,
        p.Lname
    FROM Client c
    INNER JOIN Person p ON p.person_id = c.client_id
    ORDER BY c.company_name;
END$$

DELIMITER ;
