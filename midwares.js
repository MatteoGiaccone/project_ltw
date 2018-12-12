/* Project for 'Linguaggi e Tecnologie per il Web'
 * Authors: Paolo Lucchesi, Matteo Giaccone
 * Booking handler
 */

// Required modules
const body_parser = require('body-parser');
const nodemailer = require('nodemailer');
const { Pool } = require('pg');
const config = require('./config.json');


// POST parser
const _midware_form_parser = body_parser.urlencoded({ extended: false });


/* ----------------------------------------------------------------------------
 * Validator middleware
 * ------------------------------------------------------------------------- */
function _midware_validator(req, res, next) {
	// TODO: Check hotel

	// VALIDATION
	// Matching regular expressions for form fields
	const regex = {
		name:		/^[a-z ]+$/i,
		surname:	/^[a-z ]+$/i,
		email:		/^[a-z0-9_\.]+@[a-z0-9_\.]+.[a-z0-9_\.]+$/,
		arrival:	/^(\d{4})-(\d{2})-(\d{2})$/,
		departure:	/^(\d{4})-(\d{2})-(\d{2})$/
	};

	for (r in regex) {
		if (typeof(req.body[r]) === 'undefined' || !regex[r].test(req.body[r])) {
			console.log(`Bad parameter "${r}" in booking request`, req.body);
			res.render('error', {err: 'form', bad_param: r});
			res.end();
		}
	}


	// BOOKING OBJECT
	req['booking'] = {
		hotel:		req.body.hotel,
		name:		req.body.name,
		surname:	req.body.surname,
		email:		req.body.email,
		arrival:	req.body.arrival,
		departure:	req.body.departure,
		id:			undefined,
		room:		undefined,
		price:		undefined
	};

	next();
}


/* ----------------------------------------------------------------------------
 * Database handler middleware
 * ------------------------------------------------------------------------- */
const pool = new Pool(config.db);

const query_text = 'SELECT addBooking($1,$2,$3,$4)';
/*
const query_text = 'SELECT * FROM addBooking($1,$2,$3,$4) ' +
	'AS ret(id integer, hotel varchar, room_type varchar, room smallint, ' +
	'arrival date, departure date, price float)';
*/

// Database express middleware (booker)
function _midware_booker(req, res, next) {
	// The request has been already validated by the validator middleware
	pool.query(query_text, [
		req.body.hotel,
		req.body.room_type,
		req.body.arrival,
		req.body.departure
	]).then( result => {
		// All rooms have been already booked
		// Not the cleanest and most clever way to check this anyway
		if (result.rows[0].length == 1) {
			console.log(`Hotel is busy - Aborting booking for
								${req.booking.name} ${req.booking.surname}`);
			res.render('error', {err: 'busy'});
			res.end();
		}

		// There is at least a free room - book it
		req.booking.id = result.rows[0].id;
		req.booking.room = result.rows[0].room;
		req.booking.price = result.rows[0].price;
		console.log(`Added booking ${req.booking.id} for
								${req.booking.surname} ${req.booking.name}`);

		next();
	}).catch( err => {
		if (err.code === 'P0001')	// Rooms are busy
			res.render('error', {err: 'rooms-busy'});
		else	// Generic database error
			res.render('error', {err: 'database'});
		res.end();
	});
}


/* ----------------------------------------------------------------------------
 * Mail handler middleware
 * ------------------------------------------------------------------------- */
function _midware_mailer(req, res, next) {
	const transporter = nodemailer.createTransport(config.mail);
	const booking = req.booking;

	const mail = {
		from: config.server.mail_address,
		to: 'jcondor@localhost', /* TODO: Obtain the correct address for the booked hotel */
		subject: `[Booking] ${booking.id} - ${booking.name} ${booking.surname}`,

		html: `
		<h1>/- RICHIESTA PRENOTAZIONE -/</h1>
		<table><tbody>
		<tr><td>Hotel</td><td>${booking.hotel}</td></tr>
		<tr><td>Camera</td><td>${booking.room}</td></tr>
		<tr><td>Tipo Camera</td><td>${booking.room_type}</td></tr>
		<tr><td>Data Arrivo</td><td>${booking.arrival}</td></tr>
		<tr><td>Data Partenza</td><td>${booking.departure}</td></tr>
		<tr><td>Nome</td><td>${booking.name}</td></tr>
		<tr><td>Cognome</td><td></td><td>${booking.surname}</td></tr>
		<tr><td>E-Mail</td><td></td><td>${booking.email}</td></tr>
		<tr><td>Prezzo Stimato</td><td></td><td>${booking.price}</td></tr>
		</tbody></table>\r\n;
		`
	};

	transporter.sendMail(mail, (err, info) => {
		if (err)
			console.error('Error while sending mail', err);
		else {
			console.log(`E-mail correctly sent`);
			next();
		}
	});
}


/* ----------------------------------------------------------------------------
 * Exports
 * ------------------------------------------------------------------------- */
module.exports = {
	parser:		_midware_form_parser,
	validator:	_midware_validator,
	booker:		_midware_booker,
	mailer:		_midware_mailer,
};
