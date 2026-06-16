// ============================================================================
// controllers/templateController.js  –  Freelancer: read-only templates list
// (Template Manager CRUD lives in templateAdminController.js)
// ============================================================================
const db = require('../db');

// GET /api/templates
const getTemplates = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_templates()');
        return res.json({ success: true, templates: rows[0] });
    } catch (err) {
        console.error('get templates error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch templates.' });
    }
};

module.exports = { getTemplates };
