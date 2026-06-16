// ============================================================================
// db.js  –  MySQL connection pool
// ============================================================================
const mysql = require('mysql2');

const pool = mysql.createPool({
    host     : process.env.DB_HOST     || 'localhost',
    user     : process.env.DB_USER     || 'root',
    password : process.env.DB_PASS     || 'Namal.1234',        // ← change to your MySQL root password
    database : process.env.DB_NAME     || 'upworkproposalgenerator',
    waitForConnections: true,
    connectionLimit   : 10,
    queueLimit        : 0
});

const promisePool = pool.promise();

module.exports = promisePool;
