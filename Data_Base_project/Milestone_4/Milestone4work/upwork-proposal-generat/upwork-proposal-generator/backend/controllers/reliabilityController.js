// ============================================================================
// controllers/reliabilityController.js
// ============================================================================
const db = require('../db');

// GET /api/reliability
const getReliabilityScores = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_reliability_scores()');
        return res.json({ success: true, scores: rows[0] });
    } catch (err) {
        console.error('reliability error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch reliability scores.' });
    }
};

module.exports = { getReliabilityScores };
