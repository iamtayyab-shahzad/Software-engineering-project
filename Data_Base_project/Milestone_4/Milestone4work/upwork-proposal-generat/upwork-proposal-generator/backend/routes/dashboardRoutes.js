// ============================================================================
// routes/dashboardRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const { getStats } = require('../controllers/dashboardController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.get('/stats', requireLogin, getStats);

module.exports = router;
