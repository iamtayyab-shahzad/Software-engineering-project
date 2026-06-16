-- ============================================================================
-- FILE: schema_updates.sql
-- PURPOSE: Adds Admin authentication + Reliability_Config table,
--          fixes Freelancer_Analytics to match real Generated_Proposals data.
-- Run AFTER triggers.sql, BEFORE procedures_v2.sql
-- ============================================================================

USE upworkproposalgenerator;

-- ----------------------------------------------------------------------------
-- 1. Add password column to Admin (enables Admin login via Person.email)
-- ----------------------------------------------------------------------------
ALTER TABLE Admin ADD COLUMN password VARCHAR(255) NOT NULL DEFAULT 'changeme';

-- Set real passwords for the two seeded admins
-- Admin 49 (Kashif Ali)    -> Super Admin     (manages reliability scoring config)
-- Admin 50 (Tayyab Shahzad)-> Template Manager (manages proposal templates)
UPDATE Admin SET password = 'super123'    WHERE admin_id = 49;
UPDATE Admin SET password = 'template123' WHERE admin_id = 50;

-- ----------------------------------------------------------------------------
-- 2. Reliability_Config table
--    Single-row configuration table controlling how Reliability_Score values
--    are interpreted. Managed exclusively by the Super Admin.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Reliability_Config (
    config_id INT PRIMARY KEY DEFAULT 1,

    -- Scoring weights (must sum to 100 conceptually, not enforced by DB)
    weight_jsr       DECIMAL(5,2) NOT NULL DEFAULT 50.00,  -- Job Success Rate weight
    weight_reviews   DECIMAL(5,2) NOT NULL DEFAULT 30.00,  -- Client reviews/feedback weight
    weight_payment   DECIMAL(5,2) NOT NULL DEFAULT 20.00,  -- Payment verification weight

    -- Recommendation thresholds (minimum score required for each label)
    threshold_strong_apply DECIMAL(5,2) NOT NULL DEFAULT 85.00,
    threshold_apply        DECIMAL(5,2) NOT NULL DEFAULT 65.00,
    threshold_consider      DECIMAL(5,2) NOT NULL DEFAULT 40.00,
    -- anything below threshold_consider = 'Skip'

    last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Seed the single config row (id = 1) if not already present
INSERT INTO Reliability_Config (config_id, weight_jsr, weight_reviews, weight_payment,
                                 threshold_strong_apply, threshold_apply, threshold_consider)
SELECT 1, 50.00, 30.00, 20.00, 85.00, 65.00, 40.00
WHERE NOT EXISTS (SELECT 1 FROM Reliability_Config WHERE config_id = 1);

-- ----------------------------------------------------------------------------
-- 3. One-time fix: recalculate Freelancer_Analytics from real
--    Generated_Proposals rows so Dashboard matches My Proposals.
-- ----------------------------------------------------------------------------
UPDATE Freelancer_Analytics fa
LEFT JOIN (
    SELECT
        freelancer_id,
        COUNT(*) AS total,
        SUM(CASE WHEN proposal_status = 'Accepted' THEN 1 ELSE 0 END) AS accepted,
        SUM(CASE WHEN proposal_status = 'Rejected' THEN 1 ELSE 0 END) AS rejected
    FROM Generated_Proposals
    GROUP BY freelancer_id
) gp ON gp.freelancer_id = fa.freelancer_id
SET
    fa.total_proposals    = COALESCE(gp.total, 0),
    fa.accepted_proposals = COALESCE(gp.accepted, 0),
    fa.rejected_proposals = COALESCE(gp.rejected, 0),
    fa.success_rate       = CASE
        WHEN COALESCE(gp.total, 0) > 0
        THEN ROUND((COALESCE(gp.accepted, 0) / gp.total) * 100, 2)
        ELSE 0.00
    END;
