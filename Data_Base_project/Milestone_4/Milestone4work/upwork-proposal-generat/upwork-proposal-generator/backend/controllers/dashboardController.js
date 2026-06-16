// ============================================================================
// controllers/dashboardController.js
// ============================================================================
const db = require('../db');

// GET /api/dashboard/stats
const getStats = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    try {
        const [rows] = await db.query('CALL sp_get_dashboard_stats(?)', [freelancerId]);
        const raw = rows[0][0] || { total_proposals: 0, accepted_proposals: 0, rejected_proposals: 0, success_rate: 0 };

        // mysql2 returns DECIMAL columns as strings — convert to numbers for the frontend
        const stats = {
            total_proposals   : Number(raw.total_proposals)    || 0,
            accepted_proposals: Number(raw.accepted_proposals) || 0,
            rejected_proposals: Number(raw.rejected_proposals) || 0,
            success_rate      : Number(raw.success_rate)       || 0
        };

        return res.json({ success: true, stats });
    } catch (err) {
        console.error('dashboard stats error:', err);
        return res.status(500).json({ success: false, message: 'Could not load stats.' });
    }
};

module.exports = { getStats };
