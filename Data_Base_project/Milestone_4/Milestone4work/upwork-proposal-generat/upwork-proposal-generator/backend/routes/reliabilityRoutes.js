// ============================================================================
// routes/reliabilityRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const { getReliabilityScores } = require('../controllers/reliabilityController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.get('/', requireLogin, getReliabilityScores);
module.exports = router;
