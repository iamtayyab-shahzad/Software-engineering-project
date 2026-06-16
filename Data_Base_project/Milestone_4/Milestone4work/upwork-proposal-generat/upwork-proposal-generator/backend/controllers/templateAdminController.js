// ============================================================================
// controllers/templateAdminController.js
// Template Manager only — full CRUD on Proposal_Template
// ============================================================================
const db = require('../db');

// GET /api/admin/templates
const getTemplates = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_templates_admin()');
        return res.json({ success: true, templates: rows[0] });
    } catch (err) {
        console.error('admin get templates error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch templates.' });
    }
};

// POST /api/admin/templates
const createTemplate = async (req, res) => {
    const adminId = req.session.admin.admin_id;
    const { template_name, category, template_content } = req.body;

    if (!template_name || !category || !template_content) {
        return res.status(400).json({ success: false, message: 'All fields are required.' });
    }

    try {
        const [rows] = await db.query(
            'CALL sp_create_template(?, ?, ?, ?)',
            [adminId, template_name, category, template_content]
        );
        return res.json({ success: true, template_id: rows[0][0].template_id });
    } catch (err) {
        console.error('create template error:', err);
        return res.status(500).json({ success: false, message: 'Could not create template.' });
    }
};

// PUT /api/admin/templates/:id
const updateTemplate = async (req, res) => {
    const templateId = req.params.id;
    const { template_name, category, template_content } = req.body;

    if (!template_name || !category || !template_content) {
        return res.status(400).json({ success: false, message: 'All fields are required.' });
    }

    try {
        const [rows] = await db.query(
            'CALL sp_update_template(?, ?, ?, ?)',
            [templateId, template_name, category, template_content]
        );
        if (rows[0][0].rows_affected === 0) {
            return res.status(404).json({ success: false, message: 'Template not found.' });
        }
        return res.json({ success: true });
    } catch (err) {
        console.error('update template error:', err);
        return res.status(500).json({ success: false, message: 'Could not update template.' });
    }
};

// DELETE /api/admin/templates/:id
const deleteTemplate = async (req, res) => {
    const templateId = req.params.id;
    try {
        const [rows] = await db.query('CALL sp_delete_template(?)', [templateId]);
        if (rows[0][0].rows_affected === 0) {
            return res.status(404).json({ success: false, message: 'Template not found.' });
        }
        return res.json({ success: true });
    } catch (err) {
        console.error('delete template error:', err);
        return res.status(500).json({ success: false, message: 'Could not delete template.' });
    }
};

module.exports = { getTemplates, createTemplate, updateTemplate, deleteTemplate };
