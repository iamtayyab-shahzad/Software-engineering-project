// ============================================================================
// routes/proposalRoutes.js
// ============================================================================
const express = require('express');
const router  = express.Router();
const {
    getProposals, createProposal, updateProposal, deleteProposal, getClients,
    getJobsByClient, getJobDetails, getTemplateDetails, getClientReliability
} = require('../controllers/proposalController');

const requireLogin = (req, res, next) => {
    if (!req.session.freelancer) return res.status(401).json({ success: false, message: 'Login required.' });
    next();
};

router.use(requireLogin);

router.get('/clients',                       getClients);
router.get('/jobs-by-client/:clientId',      getJobsByClient);
router.get('/job-details/:jobId',            getJobDetails);
router.get('/template-details/:templateId',  getTemplateDetails);
router.get('/client-reliability/:clientId',  getClientReliability);

router.get('/',        getProposals);
router.post('/',       createProposal);
router.put('/:id',     updateProposal);
router.delete('/:id',  deleteProposal);

module.exports = router;
