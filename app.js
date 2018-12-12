/* ----------------------------------------------------------------------------
 *	Project for 'Linguaggi e Tecnologie per il Web'
 *	Authors: Paolo Lucchesi, Matteo Giaccone
 *	Server - Main source file
 * ------------------------------------------------------------------------- */

// Required modules
const express = require('express');
const midwares = require('./midwares.js');
const config = require('./config.json');

// App configuration
var app = express();
app.set('view engine', 'ejs');


/* ----------------------------------------------------------------------------
 *	Routing
 * ------------------------------------------------------------------------- */

// Serve static files
app.use('/assets', express.static('./assets'));

// Homepage
app.get('/', (req, res) => {
	res.render('index');
});

// Structure: Baita
app.get('/baita', (req, res) => {
	res.redirect('/#baita');
});

// Structure: Chalet
app.get('/chalet', (req, res) => {
	res.redirect('/#chalet');
});

// Structure: Excelsior
app.get('/excelsior', (req, res) => {
	res.redirect('/#excelsior');
});

/*
// Project presentation page
app.get('/project', (req, res) => {
	res.render('project');
});
*/


// [SERVER] Book request received -- Proceed with the booking
// Delegate this to middlewares
app.post('/book', midwares.parser, midwares.validator, midwares.booker,
												midwares.mailer, (req, res) => {
	// TODO: Redirect to a success page, printing details for the prenotation
	res.redirect('/');
});


// 404 - Page not found
// THIS MUST BE THE LAST ROUTE!
app.get('*', (req, res) => {
	res.render('404');
});

// Let's do it
app.listen(config.server.port);
