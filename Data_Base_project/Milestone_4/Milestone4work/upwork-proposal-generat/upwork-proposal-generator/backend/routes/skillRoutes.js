// ============================================================================
// routes/skillRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const { getMySkills, getJobSkills } = require('../controllers/skillController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.get('/mine',          requireLogin, getMySkills);
router.get('/job/:jobId',     requireLogin, getJobSkills);

module.exports = router;
