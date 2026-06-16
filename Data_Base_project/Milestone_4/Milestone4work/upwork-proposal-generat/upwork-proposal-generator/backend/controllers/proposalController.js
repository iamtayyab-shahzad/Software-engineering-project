// ============================================================================
// controllers/proposalController.js
// ============================================================================
const db = require('../db');

// GET /api/proposals
const getProposals = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    try {
        const [rows] = await db.query('CALL sp_get_proposals(?)', [freelancerId]);
        return res.json({ success: true, proposals: rows[0] });
    } catch (err) {
        console.error('get proposals error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch proposals.' });
    }
};

// POST /api/proposals
const createProposal = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    const { client_id, job_id, template_id, proposal_content, proposal_status, submission_date } = req.body;

    if (!client_id || !job_id || !template_id || !proposal_content || !proposal_status) {
        return res.status(400).json({ success: false, message: 'All required fields must be filled.' });
    }

    try {
        const [rows] = await db.query(
            'CALL sp_create_proposal(?, ?, ?, ?, ?, ?, ?)',
            [freelancerId, client_id, job_id, template_id, proposal_content, proposal_status, submission_date || null]
        );
        const newId = rows[0][0].proposal_id;
        return res.json({ success: true, proposal_id: newId });
    } catch (err) {
        console.error('create proposal error:', err);
        return res.status(500).json({ success: false, message: 'Could not create proposal.' });
    }
};

// PUT /api/proposals/:id
const updateProposal = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    const proposalId   = req.params.id;
    const { proposal_content, proposal_status, submission_date } = req.body;

    if (!proposal_content || !proposal_status) {
        return res.status(400).json({ success: false, message: 'Content and status are required.' });
    }

    try {
        const [rows] = await db.query(
            'CALL sp_update_proposal(?, ?, ?, ?, ?)',
            [proposalId, freelancerId, proposal_content, proposal_status, submission_date || null]
        );
        const affected = rows[0][0].rows_affected;
        if (affected === 0) {
            return res.status(404).json({ success: false, message: 'Proposal not found or not yours.' });
        }
        return res.json({ success: true });
    } catch (err) {
        console.error('update proposal error:', err);
        return res.status(500).json({ success: false, message: 'Could not update proposal.' });
    }
};

// DELETE /api/proposals/:id
const deleteProposal = async (req, res) => {
    const freelancerId = req.session.freelancer.freelancer_id;
    const proposalId   = req.params.id;

    try {
        const [rows] = await db.query('CALL sp_delete_proposal(?, ?)', [proposalId, freelancerId]);
        const affected = rows[0][0].rows_affected;
        if (affected === 0) {
            return res.status(404).json({ success: false, message: 'Proposal not found or not yours.' });
        }
        return res.json({ success: true });
    } catch (err) {
        console.error('delete proposal error:', err);
        return res.status(500).json({ success: false, message: 'Could not delete proposal.' });
    }
};

// GET /api/proposals/clients  (form dropdown)
const getClients = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_clients()');
        return res.json({ success: true, clients: rows[0] });
    } catch (err) {
        console.error('get clients error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch clients.' });
    }
};

// GET /api/proposals/jobs-by-client/:clientId  (form dropdown, filtered)
const getJobsByClient = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_jobs_by_client(?)', [req.params.clientId]);
        return res.json({ success: true, jobs: rows[0] });
    } catch (err) {
        console.error('get jobs by client error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch jobs for this client.' });
    }
};

// GET /api/proposals/job-details/:jobId  (clickable detail view)
const getJobDetails = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_job_details(?)', [req.params.jobId]);
        if (!rows[0][0]) return res.status(404).json({ success: false, message: 'Job not found.' });
        return res.json({ success: true, job: rows[0][0] });
    } catch (err) {
        console.error('get job details error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch job details.' });
    }
};

// GET /api/proposals/template-details/:templateId  (clickable detail view)
const getTemplateDetails = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_template_details(?)', [req.params.templateId]);
        if (!rows[0][0]) return res.status(404).json({ success: false, message: 'Template not found.' });
        return res.json({ success: true, template: rows[0][0] });
    } catch (err) {
        console.error('get template details error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch template details.' });
    }
};

// GET /api/proposals/client-reliability/:clientId  (live recommendation for form)
const getClientReliability = async (req, res) => {
    try {
        const [rows] = await db.query('CALL sp_get_client_reliability(?)', [req.params.clientId]);
        return res.json({ success: true, reliability: rows[0][0] || null });
    } catch (err) {
        console.error('get client reliability error:', err);
        return res.status(500).json({ success: false, message: 'Could not fetch client reliability.' });
    }
};

module.exports = {
    getProposals, createProposal, updateProposal, deleteProposal, getClients,
    getJobsByClient, getJobDetails, getTemplateDetails, getClientReliability
};
