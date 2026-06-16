// ============================================================================
// controllers/jobController.js  –  Freelancer: read-only job listings
// (Per-job required skills are fetched separately via /api/skills/job/:jobId,
//  and full job detail for "My Proposals" click-through via
//  /api/proposals/job-details/:jobId)
// ============================================================================
const db = require('../db');

// GET /api/jobs
const getJobs = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_jobs()');
        return res.json({ success: true, jobs: rows[0] });
    } catch (err) {
        console.error('get jobs error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch jobs.' });
    }
};

module.exports = { getJobs };
