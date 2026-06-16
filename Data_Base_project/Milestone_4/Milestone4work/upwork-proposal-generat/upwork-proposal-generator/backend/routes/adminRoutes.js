// ============================================================================
// routes/adminRoutes.js
// Combines Template Manager (templates CRUD) and Super Admin (reliability config)
// routes, each protected by role-specific middleware.
// ============================================================================
const express = require('express');
const router  = express.Router();

const {
    getTemplates, createTemplate, updateTemplate, deleteTemplate
} = require('../controllers/templateAdminController');

const { getConfig, updateConfig } = require('../controllers/reliabilityConfigController');

// ── Middleware ────────────────────────────────────────────────────────────────
const requireAdminType = (type) => (req, res, next) => {
    if (!req.session.admin) {
        return res.status(401).json({ success: false, message: 'Admin login required.' });
    }
    if (req.session.admin.admin_type !== type) {
        return res.status(403).json({ success: false, message: 'You do not have permission to access this resource.' });
    }
    next();
};

const requireTemplateManager = requireAdminType('template_manager');
const requireSuperAdmin      = requireAdminType('super_admin');

// ── Template Manager: Proposal_Template CRUD ────────────────────────────────────
router.get('/templates',           requireTemplateManager, getTemplates);
router.post('/templates',          requireTemplateManager, createTemplate);
router.put('/templates/:id',       requireTemplateManager, updateTemplate);
router.delete('/templates/:id',    requireTemplateManager, deleteTemplate);

// ── Super Admin: Reliability_Config ─────────────────────────────────────────────
router.get('/reliability-config',  requireSuperAdmin, getConfig);
router.put('/reliability-config',  requireSuperAdmin, updateConfig);

module.exports = router;
