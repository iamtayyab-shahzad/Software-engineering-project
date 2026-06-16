// ============================================================================
// controllers/reliabilityConfigController.js
// Super Admin only — manages Reliability_Config (weights + thresholds)
// ============================================================================
const db = require('../db');

// GET /api/admin/reliability-config
const getConfig = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_reliability_config()');
        return res.json({ success: true, config: rows[0][0] });
    } catch (err) {
        console.error('get reliability config error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch configuration.' });
    }
};

// PUT /api/admin/reliability-config
const updateConfig = async (req, res) => {
    const {
        weight_jsr, weight_reviews, weight_payment,
        threshold_strong_apply, threshold_apply, threshold_consider
    } = req.body;

    if ([weight_jsr, weight_reviews, weight_payment, threshold_strong_apply, threshold_apply, threshold_consider]
            .some(v => v === undefined || v === null || v === '')) {
        return res.status(400).json({ success: false, message: 'All fields are required.' });
    }

    try {
        const [rows] = await db.query(
            'CALL sp_update_reliability_config(?, ?, ?, ?, ?, ?)',
            [weight_jsr, weight_reviews, weight_payment, threshold_strong_apply, threshold_apply, threshold_consider]
        );
        return res.json({ success: true, config: rows[0][0] });
    } catch (err) {
        console.error('update reliability config error:', err);
        return res.status(500).json({ success: false, message: 'Could not update configuration.' });
    }
};

module.exports = { getConfig, updateConfig };
