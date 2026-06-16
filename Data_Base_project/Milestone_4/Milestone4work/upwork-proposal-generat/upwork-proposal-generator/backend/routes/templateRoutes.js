// ============================================================================
// routes/templateRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const { getTemplates } = require('../controllers/templateController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.get('/', requireLogin, getTemplates);
module.exports = router;
