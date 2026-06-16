// ============================================================================
// controllers/skillController.js
// ============================================================================
const db = require('../db');

// GET /api/skills/mine  (Freelancer's own skills)
const getMySkills = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    try {
        const [rows] = await db.query('CALL sp_get_freelancer_skills(?)', [freelancerId]);
        return res.json({ success: true, skills: rows[0] });
    } catch (err) {
        console.error('get my skills error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch skills.' });
    }
};

// GET /api/skills/job/:jobId  (Skills required for a job)
const getJobSkills = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_job_skills(?)', [req.params.jobId]);
        return res.json({ success: true, skills: rows[0] });
    } catch (err) {
        console.error('get job skills error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch job skills.' });
    }
};

module.exports = { getMySkills, getJobSkills };
