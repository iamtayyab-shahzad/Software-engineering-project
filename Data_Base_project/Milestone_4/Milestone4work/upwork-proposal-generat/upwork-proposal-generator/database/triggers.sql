-- ============================================================================
-- FILE: triggers.sql
-- PURPOSE: Triggers that keep Freelancer_Analytics in sync automatically.
-- Run AFTER procedures.sql.
-- ============================================================================

USE upworkproposalgenerator;

DELIMITER $$

-- ============================================================================
-- TRIGGER 1: trg_after_proposal_insert
-- Fires: AFTER INSERT on Generated_Proposals
-- Action: Increments total_proposals; if status is Accepted/Rejected,
--         increments the matching counter and recalculates success_rate.
-- ============================================================================
DROP TRIGGER IF EXISTS trg_after_proposal_insert$$
CREATE TRIGGER trg_after_proposal_insert
AFTER INSERT ON Generated_Proposals
FOR EACH ROW
BEGIN
    -- Increment total proposals
    UPDATE Freelancer_Analytics
    SET total_proposals = total_proposals + 1
    WHERE freelancer_id = NEW.freelancer_id;

    -- Increment accepted counter if applicable
    IF NEW.proposal_status = 'Accepted' THEN
        UPDATE Freelancer_Analytics
        SET accepted_proposals = accepted_proposals + 1
        WHERE freelancer_id = NEW.freelancer_id;
    END IF;

    -- Increment rejected counter if applicable
    IF NEW.proposal_status = 'Rejected' THEN
        UPDATE Freelancer_Analytics
        SET rejected_proposals = rejected_proposals + 1
        WHERE freelancer_id = NEW.freelancer_id;
    END IF;

    -- Recalculate success_rate = accepted / total * 100
    UPDATE Freelancer_Analytics
    SET success_rate = CASE
        WHEN total_proposals > 0
        THEN ROUND((accepted_proposals / total_proposals) * 100, 2)
        ELSE 0.00
    END
    WHERE freelancer_id = NEW.freelancer_id;
END$$


-- ============================================================================
-- TRIGGER 2: trg_after_proposal_update
-- Fires: AFTER UPDATE on Generated_Proposals
-- Action: Fully recalculates all analytics for the freelancer from scratch
--         whenever a proposal's status changes.
-- ============================================================================
DROP TRIGGER IF EXISTS trg_after_proposal_update$$
CREATE TRIGGER trg_after_proposal_update
AFTER UPDATE ON Generated_Proposals
FOR EACH ROW
BEGIN
    DECLARE v_total    INT DEFAULT 0;
    DECLARE v_accepted INT DEFAULT 0;
    DECLARE v_rejected INT DEFAULT 0;
    DECLARE v_rate     DECIMAL(5,2) DEFAULT 0.00;

    -- Only recalculate when the status actually changed
    IF OLD.proposal_status <> NEW.proposal_status THEN

        SELECT
            COUNT(*),
            SUM(CASE WHEN proposal_status = 'Accepted' THEN 1 ELSE 0 END),
            SUM(CASE WHEN proposal_status = 'Rejected' THEN 1 ELSE 0 END)
        INTO v_total, v_accepted, v_rejected
        FROM Generated_Proposals
        WHERE freelancer_id = NEW.freelancer_id;

        IF v_total > 0 THEN
            SET v_rate = ROUND((v_accepted / v_total) * 100, 2);
        END IF;

        UPDATE Freelancer_Analytics
        SET total_proposals    = v_total,
            accepted_proposals = v_accepted,
            rejected_proposals = v_rejected,
            success_rate       = v_rate
        WHERE freelancer_id = NEW.freelancer_id;

    END IF;
END$$


-- ============================================================================
-- TRIGGER 3: trg_after_proposal_delete
-- Fires: AFTER DELETE on Generated_Proposals
-- Action: Fully recalculates all analytics for the freelancer after deletion.
-- ============================================================================
DROP TRIGGER IF EXISTS trg_after_proposal_delete$$
CREATE TRIGGER trg_after_proposal_delete
AFTER DELETE ON Generated_Proposals
FOR EACH ROW
BEGIN
    DECLARE v_total    INT DEFAULT 0;
    DECLARE v_accepted INT DEFAULT 0;
    DECLARE v_rejected INT DEFAULT 0;
    DECLARE v_rate     DECIMAL(5,2) DEFAULT 0.00;

    SELECT
        COUNT(*),
        SUM(CASE WHEN proposal_status = 'Accepted' THEN 1 ELSE 0 END),
        SUM(CASE WHEN proposal_status = 'Rejected' THEN 1 ELSE 0 END)
    INTO v_total, v_accepted, v_rejected
    FROM Generated_Proposals
    WHERE freelancer_id = OLD.freelancer_id;

    IF v_total > 0 THEN
        SET v_rate = ROUND((v_accepted / v_total) * 100, 2);
    END IF;

    UPDATE Freelancer_Analytics
    SET total_proposals    = v_total,
        accepted_proposals = v_accepted,
        rejected_proposals = v_rejected,
        success_rate       = v_rate
    WHERE freelancer_id = OLD.freelancer_id;
END$$

DELIMITER ;
