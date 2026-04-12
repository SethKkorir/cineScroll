const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'cinescroll_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

const db = pool.promise();

app.post('/users', async (req, res) => {
    const { full_name, email, password } = req.body;
    try {
        const [result] = await db.execute(
            'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
            [full_name || null, email || null, password || null]
        );
        res.status(201).json({ message: "User registered successfully", user_id: result.insertId });
    } catch (error) {
        console.error("Signup Error:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const [rows] = await db.execute(
            'SELECT * FROM users WHERE email = ? AND password = ?',
            [email || null, password || null]
        );
        if (rows.length > 0) {
            res.status(200).json({ success: true, message: "Login successful", user: rows[0] });
        } else {
            res.status(401).json({ success: false, message: "Invalid credentials" });
        }
    } catch (error) {
        console.error("Login Error:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('/movies', async (req, res) => {
    try {
        const [rows] = await db.execute('SELECT * FROM movies');
        res.json(rows);
    } catch (error) {
        console.error("Movies Error:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/movies', async (req, res) => {
    // Destructuring values from Postman request
    const { title, description, poster_url, release_date, rating } = req.body;

    try {
        // We use "|| null" to ensure we never send "undefined" to MySQL
        const [result] = await db.execute(
            'INSERT INTO movies (title, description, poster_url, release_date, rating) VALUES (?, ?, ?, ?, ?)',
            [
                title || null,
                description || null,
                poster_url || null,
                release_date || null,
                rating || null
            ]
        );
        res.status(201).json({ message: "Movie added successfully", movie_id: result.insertId });
    } catch (error) {
        console.error("Add Movie Error:", error);
        res.status(500).json({ error: 'Internal Server Error', details: error.message });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Backend Server running on port ${PORT}`);
});
