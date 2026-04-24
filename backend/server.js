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
    const { fullName, full_name, email, password } = req.body;
    const nameToInsert = full_name || fullName;

    if (!email || !password) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    try {
        const [result] = await db.execute(
            'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
            [nameToInsert || null, email, password]
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
            // Return the first user found
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
        console.log(`Fetched ${rows.length} movies`);
        res.json(rows);
    } catch (error) {
        console.error('Database error in GET /movies:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

app.post('/movies', async (req, res) => {
    const { title, description, posterUrl, videoUrl, releaseDate, rating, sourceType } = req.body;
    if (!title) {
        return res.status(400).json({ error: 'Title is required' });
    }
    try {
        const [result] = await db.execute(
            'INSERT INTO movies (title, description, posterUrl, videoUrl, releaseDate, rating, sourceType) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
                title,
                description || null,
                posterUrl || null,
                videoUrl || null,
                releaseDate || null,
                rating || null,
                sourceType || 'network'
            ]
        );
        res.status(201).json({ movie_id: result.insertId });
    } catch (error) {
        console.error('Database error in POST /movies:', error);
        res.status(500).json({ error: 'Database Error', details: error.message });
    }
});

// --- WATCHLIST ENDPOINTS ---

// 1. Get watchlist for a user
app.get('/watchlist/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const [rows] = await db.execute(
            'SELECT m.* FROM movies m JOIN watchlist w ON m.id = w.movie_id WHERE w.user_id = ?',
            [userId]
        );
        res.json(rows);
    } catch (error) {
        console.error('Error fetching watchlist:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

// 2. Add to watchlist
app.post('/watchlist', async (req, res) => {
    const { userId, user_id, movieId, movie_id } = req.body;
    const final_uid = user_id || userId;
    const final_mid = movie_id || movieId;

    try {
        await db.execute(
            'INSERT IGNORE INTO watchlist (user_id, movie_id) VALUES (?, ?)',
            [final_uid, final_mid]
        );
        res.status(201).json({ success: true, message: 'Added to watchlist' });
    } catch (error) {
        console.error('Error adding to watchlist:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

// 3. Remove from watchlist
app.delete('/watchlist/:userId/:movieId', async (req, res) => {
    const { userId, movieId } = req.params;
    try {
        await db.execute(
            'DELETE FROM watchlist WHERE user_id = ? AND movie_id = ?',
            [userId, movieId]
        );
        res.json({ success: true, message: 'Removed from watchlist' });
    } catch (error) {
        console.error('Error removing from watchlist:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

// --- USER PROFILE & STATS ENDPOINTS ---

// Get user profile details
app.get('/users/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [rows] = await db.execute('SELECT id, full_name, email, bio, profile_url, created_at FROM users WHERE id = ?', [id]);
        if (rows.length > 0) {
            res.json(rows[0]);
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

// Get user stats (Watchlist count)
app.get('/users/:id/stats', async (req, res) => {
    const { id } = req.params;
    try {
        const [rows] = await db.execute('SELECT COUNT(*) as watchlistCount FROM watchlist WHERE user_id = ?', [id]);
        res.json(rows[0]);
    } catch (error) {
        console.error('Error fetching stats:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

// Update user profile (Bio, Name, Profile Image)
app.put('/users/:id', async (req, res) => {
    const { id } = req.params;
    const { fullName, full_name, bio, profileUrl, profile_url } = req.body;
    try {
        await db.execute(
            'UPDATE users SET full_name = ?, bio = ?, profile_url = ? WHERE id = ?',
            [full_name || fullName, bio || null, profile_url || profileUrl, id]
        );
        res.json({ success: true, message: 'Profile updated' });
    } catch (error) {
        console.error('Error updating profile:', error);
        res.status(500).json({ error: 'Database Error' });
    }
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
});
