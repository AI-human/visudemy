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



// ===================== Auth ===================== 


// insert auth data

app.post('/auth',async (req, res) => {
  const username = req.body.username;
  const email = req.body.email;
  const passwd = req.body.passwd;
  try{
    const result = await db.query('insert into auth values($1,$2,$3)', [username,email,passwd])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while inserting data into auth table.' });
  }
});


// get auth data

app.get('/auth/:username',async (req, res) => {
  const username = req.params.username;
  try{
    const result = await db.query('select * from auth where user_name=$1', [username])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){ 
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while fetching CGPA data.' });
  }
});

// update passwd

app.patch('/auth/:username',async (req, res) => {
  const username = req.params.username;
  const passwd = req.body.passwd;
  try{
    const result = await db.query('update auth set passwd=$1 where user_name=$2', [passwd,username])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while updating password in auth table.' });
  }
});

// del auth


app.delete('/auth/:username',async (req, res) => {

  const username = req.params.username;
  try{
    const result = await db.query('delete from auth where user_name=$1', [username])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while deleting data from auth table.' });
  }

});

// --------------------- Auth End ---------------------

// ===================== profile =====================
app.get('/profile/:username', async (req, res) => {
  try {
    const result = await db.query('SELECT get_profile_data($1)', [req.params.username]);
    res.send(result.rows[0].get_profile_data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred while fetching CGPA data.' });
  }
});

// ===================== CGPA =====================
app.post('/insert_cgpa',async (req, res) => {
  const username = req.body.username;
  const admitted = req.body.admitted;
  const graduate = req.body.graduate;
  const sem1 = req.body.sem1;
  const sem2 = req.body.sem2;
  const sem3 = req.body.sem3;
  const sem4 = req.body.sem4;
  const sem5 = req.body.sem5;
  const sem6 = req.body.sem6;
  const sem7 = req.body.sem7;
  const sem8 = req.body.sem8;
  try{
    const result = await db.query('select insert_into_cgpa($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)', [username, admitted, graduate, sem1, sem2, sem3, sem4, sem5, sem6, sem7, sem8 ])
    // console.log(result);
    res.json(result.rows);
  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while inserting data into auth table.' });
  }
});




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


// nested query
app.get('/users/high-cgpa', async (req, res) => {

  try {
    const result = await db.query('SELECT get_users_with_high_cgpa()');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred while fetching data.' });
  }
});

// ===================== CGPA End =====================

// ===================== Codeforce =====================

// join query
app.get('/top-solvers', async (req, res) => {
  try {
    const result = await db.query('SELECT get_top_solvers()');
    res.status(200).json(result.rows[0].get_top_solvers);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: `An error occurred: ${err.message}` });
  }
});

// ===================== Codeforce End =====================
// ===================== project  =====================

app.get('/top-skills-projects', async (req, res) => {
  try {
    const result = await db.query('SELECT get_top_skill_and_project_user()');
    res.status(200).json(result.rows[0].get_top_skill_and_project_user);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: `An error occurred: ${err.message}` });
  }
});
//

// ===================== project End =====================

// ===================== github =====================
app.get('/top-repos', async (req, res) => {
  try {
    const result = await db.query('SELECT get_top_repos()');
    res.status(200).json(result.rows[0].get_top_repos);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: `An error occurred: ${err.message}` });
  }
});



// ===================== connection =====================

app.get('/connection/:username',async (req, res) => {
  const username = req.params.username;
  const limit = parseInt(req.query.limit)
  const offset = parseInt(req.query.offset)

  try{
    const result = await db.query('select * from connection where user_name=$1 limit $2 offset $3', [username,limit,offset])
    // console.log(result);
    res.json(result.rows);

  }
  catch(error){
    // console.error('Error:', error);
    res.status(500).json({ error: 'An error occurred while getting data from connection table.' });
    
  }
}
);


// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
