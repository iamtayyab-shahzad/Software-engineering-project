// ============================================================================
// routes/jobRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const { getJobs } = require('../controllers/jobController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.get('/', requireLogin, getJobs);
module.exports = router;
