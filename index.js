const express = require('express');
const path = require('path');
const mysql2 = require('mysql2');
var bodyParser = require("body-parser");

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
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Set a static folder
app.use(express.static(path.join(__dirname, 'public')));

//Set a GET routine at '/'
app.get('/', (req, res) =>{
    res.render('index');
});

//Handle AJAX requests
//Query the DB if a login id exists and send back data for autofill
app.get('/people_request', (req, res) =>{
    //console.log(req.query.login_qu);

    // select query
    mysql.query('SELECT * FROM people WHERE login = ?', [req.query.login_qu],
    function(err, data) {
        //console.log(data);
        res.json(data);
    });
});
//Query the db if a team exists and send back data for autofill /teams_request
app.get('/teams_request', (req, res) =>{
    //console.log(req.query.teamname_qu);

    // select query
    mysql.query('SELECT * FROM teams WHERE teamName = ?', [req.query.teamname_qu],
    function(err, data) {
        //console.log(data);
        res.json(data);
    });
});

//INSERT queries here
app.post('/addPersonRequest', (req, res) =>{
    // insert query
    mysql.query(
        'INSERT INTO people (login, firstName, lastName, contactInfo, notes) VALUES (?, ?, ?, ?, ?)',
        [req.body.login, req.body.firstName, req.body.lastName, req.body.contactInfo, req.body.notes],
        function (err, rows) {
            // rows contains info about what was inserted
            //console.log(req.body);
            //console.log(err);
            
            if (req.body.TEid != -1 && !err ) {
                //console.log('id of the inserted row', rows.insertId);
                // insert query
                mysql.query(
                    'INSERT INTO team_membership (TEid, LOGid) VALUES (?, ?)',
                    [req.body.TEid, rows.insertId],
                    function (err, rows) {
                        // rows contains info about what was inserted
                        //console.log(req.body);
                        //console.log(err);
                });
            } else if (req.body.LOGid != -1 && req.body.TEid != -1) {
                // select query
                mysql.query('SELECT TEid, LOGid FROM team_membership WHERE TEid = ? AND LOGid = ?', [req.body.TEid, req.body.LOGid],
                function(err, data) {
                    //console.log(data);
                    if (data.length == 0) {
                        // insert query
                        mysql.query(
                            'INSERT INTO team_membership (TEid, LOGid) VALUES (?, ?)',
                            [req.body.TEid, req.body.LOGid],
                            function (err, rows) {
                                //console.log(err);
                        });
                    };
                });
            };
    });
});
app.post('/addTeamRequest', (req, res) =>{
    // insert query
    console.log('Uh huh');
    mysql.query(
        'INSERT INTO teams (teamName, description, notes) VALUES (?, ?, ?)',
        [req.body.teamName, req.body.description, req.body.notes],
        function (err, rows) {
            // rows contains info about what was inserted
            console.log(req.body);
    });
});


//Handle the submission POST request
app.post('/submit', (req, res) =>{
    // insert query
    console.log('Uh huh', req.body);
    
    //debug line
    //res.json(req.body);

    // Check if the Team is lodged....  prepare for non modular nesting madnessss?!!!!!>!>!>!>!?!?!??!?!?!?!R&%$^&#$%^%$*%$#
    // TODO function this off for modularity sake
    // insert query
    // Attempting to lodge the team
    console.log('Uh huh');
    mysql.query(
        'INSERT INTO teams (teamName, description, notes) VALUES (?, ?, ?)',
        [req.body.teams_teamName, req.body.teams_description, req.body.teams_notes],
        function (err, rows) {

            //securing the TEid regardless of lodgement
            var TEid = req.body.teams_TEid
            if (TEid == -1) {
                TEid = rows.insertId;
            };
            //Attempt to insert the person
            mysql.query(
                'INSERT INTO people (login, firstName, lastName, contactInfo, notes) VALUES (?, ?, ?, ?, ?)',
                [req.body.people_Login, req.body.people_firstname, req.body.people_lastname, req.body.people_contact_info, req.body.people_notes],
                function (err, rows) {

                    //Secure the LOGid regardless of lodgement
                    var LOGid = req.body.people_LOGid
                    if (LOGid == -1) {
                        LOGid = rows.insertId;
                    };

                    //Attempt to create the team membership relationship
                    // select query
                    mysql.query('SELECT TEid, LOGid FROM team_membership WHERE TEid = ? AND LOGid = ?', [TEid, LOGid],
                    function(err, data) {
                        //console.log(data);
                        if (data.length == 0) {
                            // insert query
                            mysql.query(
                                'INSERT INTO team_membership (TEid, LOGid) VALUES (?, ?)',
                                [req.body.TEid, req.body.LOGid],
                                function (err, rows) {
                                    //console.log(err);
                            });
                        };
                    });

                    //Attempt to create the feature request itself
                    // insert query
                    // insert query
                    mysql.query(
                        'INSERT INTO feature_request (lOGid, TEid, procName, oldDesc, noStaff, maintenance, report_require) VALUES (?, ?, ?, ?, ?, ?, ?)',
                        [LOGid, TEid, req.body.ProcName, req.body.OldDesc, req.body.NoStaff, req.body.maintenance, req.body.reporting],
                        function (err, rows) {
                            console.log(err);
                            console.log(rows);
                            res.render('index');
                    });
            });
    });



    

});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

