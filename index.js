const express = require('express');
const path = require('path');

const logger = require('./middleware/logger')
const app = express();

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

// Members api routes
app.use('/api/members', require('./routes/api/members'));

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

/*
const app = require('express')();
const path = require('path');

//Set directory and views engine as handlebars
app.set('views', path.join(__dirname, "views"));
app.set("view engine", "hbs");

//Set a GET routine at '/'
app.get('/', (req, res) =>{
    let peoplelist = getRandomList(); //fetch a random list of people's names
    res.render('index', {people: peoplelist});
});

//people list generator
let getRandomList = () => {
    let list = ["ada", "turing", "lovelace", "nuemann", "gracehopper"];
    let limit = Math.floor(Math.random() * (list.length - 1 - 0) + 0); //generating random number between 0 and 4
    return list.slice(limit);
}

//Setting the port for listening
app.listen(5000);
*/