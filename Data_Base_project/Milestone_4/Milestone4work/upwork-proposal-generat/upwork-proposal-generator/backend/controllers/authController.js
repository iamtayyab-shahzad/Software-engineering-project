// ============================================================================
// controllers/authController.js  –  Freelancer authentication
// ============================================================================
const db = require('../db');

// POST /api/auth/signup
const signup = async (req, res) => {
    const { f_name, lname, email, password } = req.body;

    if (!f_name || !lname || !email || !password) {
        return res.status(400).json({ success: false, message: 'All fields are required.' });
    }

    try {
        const [rows] = await db.query('CALL sp_signup_freelancer(?, ?, ?, ?)', [f_name, lname, email, password]);
        const freelancer = rows[0][0];
        req.session.freelancer = freelancer;
        return res.json({ success: true, freelancer });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ success: false, message: 'Email already registered.' });
        }
        console.error('signup error:', err);
        return res.status(500).json({ success: false, message: 'Server error during signup.' });
    }
};

// POST /api/auth/login
const login = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Email and password are required.' });
    }

    try {
        const [rows] = await db.query('CALL sp_login_freelancer(?, ?)', [email, password]);
        const freelancer = rows[0][0];

        if (!freelancer) {
            return res.status(401).json({ success: false, message: 'Invalid email or password.' });
        }

        req.session.freelancer = freelancer;
        return res.json({ success: true, freelancer });
    } catch (err) {
        console.error('login error:', err);
        return res.status(500).json({ success: false, message: 'Server error during login.' });
    }
};

// POST /api/auth/logout
const logout = (req, res) => {
    req.session.destroy(() => {
        res.json({ success: true });
    });
};

// GET /api/auth/me
const me = (req, res) => {
    if (req.session.freelancer) {
        return res.json({ success: true, freelancer: req.session.freelancer });
    }
    return res.status(401).json({ success: false, message: 'Not logged in.' });
};

module.exports = { signup, login, logout, me };
