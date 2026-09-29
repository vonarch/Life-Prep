const express = require("express");
const mysql = require("mysql2");

const app = express();
const PORT = 3000;

/*

npm init -y
npm install express mysql2

*/

// Allow JSON data
app.use(express.json());


// Serve the html pages
app.use(express.static(__dirname));


// Connect to MySQL
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "life_prep_db"
});


// Test database connection
db.connect((err) => {

    if (err) {
        console.error("Database connection failed:", err);
        return;
    }

    console.log("Connected to MySQL");

});


// ========================================
// PREPS
// ========================================

// GET - Retrieve Preps
app.get("/api/preps", (req, res) => {

    const sql = "SELECT * FROM preps ORDER BY id DESC";

    db.query(sql, (err, results) => {

        if (err) {
            return res.status(500).json({
                message: "Database error"
            });
        }

        res.json(results);

    });

});


// POST - Insert Prep
app.post("/api/preps", (req, res) => {

    const { title, category, description, source } = req.body;

    if (!title || !category) {
        return res.status(400).json({
            message: "Title and category are required"
        });
    }

    const sql = `
        INSERT INTO preps
        (title, category, description, source)
        VALUES (?, ?, ?, ?)
    `;

    db.query(
        sql,
        [title, category, description || "", source || ""],
        (err, result) => {

            if (err) {
                return res.status(500).json({
                    message: "Database error"
                });
            }

            res.status(201).json({
                message: "Prep added successfully",
                id: result.insertId
            });

        }
    );

});


// ========================================
// MATERIALS
// ========================================

// GET - Retrieve Materials (with the prep title)
app.get("/api/materials", (req, res) => {

    const sql = `
        SELECT materials.id, materials.name, materials.quantity,
               preps.title AS prep_title
        FROM materials
        JOIN preps ON preps.id = materials.prep_id
        ORDER BY preps.title, materials.id
    `;

    db.query(sql, (err, results) => {

        if (err) {
            return res.status(500).json({
                message: "Database error"
            });
        }

        res.json(results);

    });

});


// POST - Insert Material
app.post("/api/materials", (req, res) => {

    const { prep_id, name, quantity } = req.body;

    if (!prep_id || !name) {
        return res.status(400).json({
            message: "Prep and material name are required"
        });
    }

    const sql = `
        INSERT INTO materials
        (prep_id, name, quantity)
        VALUES (?, ?, ?)
    `;

    db.query(
        sql,
        [prep_id, name, quantity || ""],
        (err, result) => {

            if (err) {
                return res.status(500).json({
                    message: "Database error"
                });
            }

            res.status(201).json({
                message: "Material added successfully",
                id: result.insertId
            });

        }
    );

});


// ========================================
// STEPS (GUIDE)
// ========================================

// GET - Retrieve Steps (with the prep title)
app.get("/api/steps", (req, res) => {

    const sql = `
        SELECT steps.id, steps.step_number, steps.instruction,
               preps.title AS prep_title
        FROM steps
        JOIN preps ON preps.id = steps.prep_id
        ORDER BY preps.title, steps.step_number
    `;

    db.query(sql, (err, results) => {

        if (err) {
            return res.status(500).json({
                message: "Database error"
            });
        }

        res.json(results);

    });

});


// POST - Insert Step
// step_number is set automatically (next number for that prep)
app.post("/api/steps", (req, res) => {

    const { prep_id, instruction } = req.body;

    if (!prep_id || !instruction) {
        return res.status(400).json({
            message: "Prep and instruction are required"
        });
    }

    const sql = `
        INSERT INTO steps (prep_id, step_number, instruction)
        SELECT ?, COALESCE(MAX(step_number), 0) + 1, ?
        FROM steps
        WHERE prep_id = ?
    `;

    db.query(
        sql,
        [prep_id, instruction, prep_id],
        (err, result) => {

            if (err) {
                return res.status(500).json({
                    message: "Database error"
                });
            }

            res.status(201).json({
                message: "Step added successfully",
                id: result.insertId
            });

        }
    );

});


// ========================================
// Start Server
// ========================================

app.listen(PORT, () => {

    console.log(
        `Server running at http://localhost:${PORT}`
    );

});