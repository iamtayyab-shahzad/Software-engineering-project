// ============================================================================
// controllers/adminAuthController.js
// ============================================================================
const db = require('../db');

// POST /api/admin-auth/login
const login = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Email and password are required.' });
    }

    try {
        const [rows] = await db.query('CALL sp_login_admin(?, ?)', [email, password]);
        const admin = rows[0][0];

        if (!admin) {
            return res.status(401).json({ success: false, message: 'Invalid email or password.' });
        }

        req.session.admin = admin;
        return res.json({ success: true, admin });
    } catch (err) {
        console.error('admin login error:', err);
        return res.status(500).json({ success: false, message: 'Server error during admin login.' });
    }
};

// POST /api/admin-auth/logout
const logout = (req, res) => {
    req.session.destroy(() => res.json({ success: true }));
};

// GET /api/admin-auth/me
const me = (req, res) => {
    if (req.session.admin) {
        return res.json({ success: true, admin: req.session.admin });
    }
    return res.status(401).json({ success: false, message: 'Not logged in.' });
};

module.exports = { login, logout, me };
