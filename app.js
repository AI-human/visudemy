const express = require('express');
const bodyParser = require('body-parser');
const pg = require('pg');
const app = express();
const port = 3000;

// Set up the PostgreSQL database connection

const db = new pg.Client({
  user:'postgres',
  password:'1234',
  database:'visudemy',
  host:'localhost',
  port:'5432'
});

(async () => {
  await db.connect();
})();

// Middleware to parse JSON requests
app.use(bodyParser.json());

// Define a route for getting CGPA data by username
app.get('/cgpa/:username',async (req, res) => {
  const username = req.params.username;
  try{
    const result = await db.query('select get_cgpa_by_username($1)', [username])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while fetching CGPA data.' });
  }
});


// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
