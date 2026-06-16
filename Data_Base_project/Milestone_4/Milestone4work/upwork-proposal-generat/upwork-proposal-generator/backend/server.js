// ============================================================================
// server.js  –  Express entry point
// ============================================================================
const express = require('express');
const session = require('express-session');
const cors    = require('cors');
const path    = require('path');

const authRoutes        = require('./routes/authRoutes');
const dashboardRoutes   = require('./routes/dashboardRoutes');
const proposalRoutes    = require('./routes/proposalRoutes');
const templateRoutes    = require('./routes/templateRoutes');
const jobRoutes         = require('./routes/jobRoutes');
const reliabilityRoutes = require('./routes/reliabilityRoutes');
const skillRoutes       = require('./routes/skillRoutes');
const adminAuthRoutes   = require('./routes/adminAuthRoutes');
const adminRoutes       = require('./routes/adminRoutes');

const app  = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(session({
    secret           : 'upwork_milestone3_secret_key',
    resave           : false,
    saveUninitialized: false,
    cookie           : { maxAge: 1000 * 60 * 60 * 8 }  // 8 hours
}));

// ── Serve frontend static files ───────────────────────────────────────────────
app.use(express.static(path.join(__dirname, '../frontend')));

// ── API Routes ────────────────────────────────────────────────────────────────
app.use('/api/auth',         authRoutes);
app.use('/api/dashboard',    dashboardRoutes);
app.use('/api/proposals',    proposalRoutes);
app.use('/api/templates',    templateRoutes);
app.use('/api/jobs',         jobRoutes);
app.use('/api/reliability',  reliabilityRoutes);
app.use('/api/skills',       skillRoutes);
app.use('/api/admin-auth',   adminAuthRoutes);
app.use('/api/admin',        adminRoutes);

// ── Root redirect ─────────────────────────────────────────────────────────────
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/login.html'));
});

// ── Start ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
