const express = require('express');
const path = require('path');
const mysql2 = require('mysql2');

const logger = require('./middleware/logger')
const app = express();

//Database stuff
var mysql = mysql2.createPool({
    connectionLimit: 100,
    host     : 'localhost',
    user     : 'fraudtech_client',
    password : 'Fraudulent',
    database : 'fraudtech_feature_request'
});

//Set directory and views engine as handlebars
app.set('views', path.join(__dirname, "views"));
app.set("view engine", "hbs");

// Init middleware
app.use(logger);

// Body Parser Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false}));

// Set a static folder
app.use(express.static(path.join(__dirname, 'public')));

//Set a GET routine at '/'
app.get('/', (req, res) =>{
    res.render('index');
});
app.get('/people_request', (req, res) =>{
    console.log(req.query.login_qu);

    // select query
    mysql.query('SELECT * FROM people WHERE login = ?', [req.query.login_qu]
    function(err, data) {
        console.log(data);
        res.json(data);
    });
    res.end();
});

//

/*app.get('/butt', (req, res) =>{
    // insert query
    mysql.query(
        'INSERT INTO people (firstName, lastName, contactInfo, notes) VALUES (?, ?, ?, ?)',
        ['Bob', 'Barker', 'bob@fridge.com', 'Bob is a furious advocate for attack helicoptors'],
        function (err, rows) {
            // rows contains info about what was inserted
            console.log(rows);
            console.log('id of the inserted row', rows.insertId);
        }
    );
});

app.get('/buttocks', (req, res) =>{
    // select query
    mysql.query('SELECT * FROM people', 
    function(err, data) {
        console.log(data);
        res.json(data);
    });
});*/

app.post('/submit', (req, res) =>{
    res.json(req.body);
    /*{"Login":"123",
    "Name":"Placeholder Person", "Team":"12",
    "ProcName":"afsdf", "OldDesc":"gjhg",
    "NoStaff":"6", "feature_1":"sdgas",
    "feature_2":"yes","feature_3":"ddddddd",
    "maintenance":"ongoing maintenencement",
    "stakeHolder_1":"banana","stakeHolder_2":"apple",
    "stakeHolder_3":"Jeffers","Attach":"export (6).xml"} */

})

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

