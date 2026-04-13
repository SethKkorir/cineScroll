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

// Helper: Validate inputs
function validateUserInput(full_name, email, password) {
    if (!email || !password) return false;
    return true;
}

function validateMovieInput(title, description, poster_url, video_url, release_date, rating) {
    if (!title) return false;
    return true;
}

app.post('/users', async (req, res) => {
    const { full_name, email, password } = req.body;
    if (!validateUserInput(full_name, email, password)) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    try {
        const [result] = await db.execute(
            'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
            [full_name || null, email, password]
        );
        res.status(201).json({ user_id: result.insertId });
    } catch (error) {
        console.error('Database error in /users:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password required' });
    }
    try {
        const [rows] = await db.execute(
            'SELECT * FROM users WHERE email = ? AND password = ?',
            [email, password]
        );
        if (rows.length > 0) {
            res.status(200).json({ success: true, user: rows[0] });
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (error) {
        console.error('Database error in /login:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

app.get('/movies', async (req, res) => {
    try {
        const [rows] = await db.execute('SELECT * FROM movies');
        res.json(rows);
    } catch (error) {
        console.error('Database error in GET /movies:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

app.post('/movies', async (req, res) => {
    const { title, description, poster_url, video_url, release_date, rating } = req.body;
    if (!validateMovieInput(title, description, poster_url, video_url, release_date, rating)) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    try {
        const [result] = await db.execute(
            'INSERT INTO movies (title, description, poster_url, video_url, release_date, rating) VALUES (?, ?, ?, ?, ?, ?)',
            [
                title,
                description || null,
                poster_url || null,
                video_url || null,
                release_date || null,
                rating || null
            ]
        );
        res.status(201).json({ movie_id: result.insertId });
    } catch (error) {
        console.error('Database error in POST /movies:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
});
