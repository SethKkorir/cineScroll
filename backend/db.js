const mysql = require('mysql2/promise'); // Explicitly import the promise version

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'cinescroll_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
}); 

pool.on('connection', () => {
    console.log('Database connection established');
});

module.exports = pool;
