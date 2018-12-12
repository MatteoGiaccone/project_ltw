-- <--------------------------------------------------------------------------
--   Linguaggi e Tecnologie per il Web - Progetto
--   Database Initialization
--   Paolo Lucchesi, Matteo Giaccone
--  -------------------------------------------------------------------------->


-- ----------------------------------------------------------------------------
-- Create tables and sequences
-- ----------------------------------------------------------------------------
BEGIN;

CREATE TABLE hotel (
	name	varchar		PRIMARY KEY,
	email	varchar		NOT NULL,
	stars	smallint	NOT NULL CHECK (stars > 0 AND stars < 6),
	geo_x	smallint	NOT NULL,
	geo_y	smallint	NOT NULL
);

CREATE TABLE room (
	hotel	varchar		REFERENCES hotel(name),
	num		smallint	CHECK (num > 0),
	"type"	varchar		NOT NULL,
	price	float		NOT NULL,

	PRIMARY KEY (hotel, num),

	-- Without the constraint below the database is seen as inconsistent, even
	-- if (hotel,num) is the primary key (and it is implicitly UNIQUE)
	UNIQUE (hotel, num, "type")
);

CREATE SEQUENCE booking_id START 1;

CREATE TABLE booking (
	id			integer		PRIMARY KEY,
	hotel		varchar		NOT NULL,
	room_type	varchar		NOT NULL,
	room		smallint	NOT NULL,
	name		varchar		NOT NULL,
	surname		varchar		NOT NULL,
	arrival		date		NOT NULL,
	departure	date		NOT NULL,
	price		float		NOT NULL CHECK (price > 0),

	FOREIGN KEY (hotel, room, room_type) REFERENCES room(hotel, num, "type"),
	CHECK (arrival < departure)
);

COMMIT;


-- ----------------------------------------------------------------------------
-- Instantiate records
-- ----------------------------------------------------------------------------
BEGIN;

INSERT INTO hotel VALUES
	('Baita',		'baita@sudtirolhotelgroup.it',		3, 54.66,	62.55),
	('Chalet',		'chalet@sudtirolhotelgroup.it',		3, 58.00,	59.33),
	('Excelsior',	'excelsior@sudtirolhotelgroup.it',	5, 53.96,	60.04);

INSERT INTO room VALUES

	-- Baita
	('Baita', 11, 'Singola',	40.00),
	('Baita', 12, 'Singola',	40.00),
	('Baita', 13, 'Doppia',		75.00),
	('Baita', 14, 'Doppia',		75.00),
	('Baita', 15, 'Tripla',		100.00),
	('Baita', 16, 'Quadrupla',	125.00),
	('Baita', 17, 'Singola',	40.00),
	('Baita', 18, 'Singola',	40.00),
	('Baita', 19, 'Doppia',		75.00),
	('Baita', 21, 'Doppia',		75.00),
	('Baita', 22, 'Tripla',		100.00),
	('Baita', 23, 'Quadrupla',	125.00),
	('Baita', 24, 'Singola',	40.00),
	('Baita', 25, 'Singola',	40.00),
	('Baita', 26, 'Doppia',		75.00),
	('Baita', 27, 'Doppia',		75.00),
	('Baita', 28, 'Tripla',		100.00),
	('Baita', 29, 'Quadrupla',	125.00),
	('Baita', 31, 'Singola',	40.00),
	('Baita', 32, 'Singola',	40.00),
	('Baita', 33, 'Doppia',		75.00),
	('Baita', 34, 'Doppia',		75.00),
	('Baita', 35, 'Tripla',		100.00),
	('Baita', 36, 'Quadrupla',	125.00),

	-- Chalet
	('Chalet', 11, 'Singola',	90.00),
	('Chalet', 12, 'Singola',	90.00),
	('Chalet', 13, 'Doppia',	170.00),
	('Chalet', 14, 'Doppia',	170.00),
	('Chalet', 15, 'Tripla',	220.00),
	('Chalet', 16, 'Quadrupla',	195.00),
	('Chalet', 17, 'Singola',	90.00),
	('Chalet', 18, 'Singola',	90.00),
	('Chalet', 19, 'Doppia',	170.00),
	('Chalet', 21, 'Doppia',	170.00),
	('Chalet', 22, 'Tripla',	220.00),
	('Chalet', 23, 'Quadrupla',	195.00),
	('Chalet', 24, 'Singola',	90.00),
	('Chalet', 25, 'Singola',	90.00),
	('Chalet', 26, 'Doppia',	170.00),
	('Chalet', 27, 'Doppia',	170.00),
	('Chalet', 28, 'Tripla',	220.00),
	('Chalet', 29, 'Quadrupla',	195.00),
	('Chalet', 31, 'Singola',	90.00),
	('Chalet', 32, 'Singola',	90.00),
	('Chalet', 33, 'Doppia',	170.00),
	('Chalet', 34, 'Doppia',	170.00),
	('Chalet', 35, 'Tripla',	220.00),
	('Chalet', 36, 'Quadrupla',	195.00),

	-- Excelsior
	('Excelsior', 11, 'Singola',	280.00),
	('Excelsior', 12, 'Singola',	280.00),
	('Excelsior', 13, 'Doppia',		560.00),
	('Excelsior', 14, 'Doppia',		560.00),
	('Excelsior', 15, 'Tripla',		1100.00),
	('Excelsior', 16, 'Quadrupla',	1300.00),
	('Excelsior', 17, 'Singola',	280.00),
	('Excelsior', 18, 'Singola',	280.00),
	('Excelsior', 19, 'Doppia',		560.00),
	('Excelsior', 21, 'Doppia',		560.00),
	('Excelsior', 22, 'Tripla',		1100.00),
	('Excelsior', 23, 'Quadrupla',	1300.00),
	('Excelsior', 24, 'Singola',	280.00),
	('Excelsior', 25, 'Singola',	280.00),
	('Excelsior', 26, 'Doppia',		560.00),
	('Excelsior', 27, 'Doppia',		560.00),
	('Excelsior', 28, 'Tripla',		1100.00),
	('Excelsior', 29, 'Quadrupla',	1300.00),
	('Excelsior', 31, 'Singola',	280.00),
	('Excelsior', 32, 'Singola',	280.00),
	('Excelsior', 33, 'Doppia',		560.00),
	('Excelsior', 34, 'Doppia',		560.00),
	('Excelsior', 35, 'Tripla',		1100.00),
	('Excelsior', 101,'Suite',		3500.00),
	('Excelsior', 102,'Suite',		3500.00),
	('Excelsior', 103,'Suite',		3500.00),
	('Excelsior', 104,'Suite Presidenziale', 9000.00),
	('Excelsior', 105,'Attico',		12000.00),
	('Excelsior', 106,'Ultra Luxe',	30000.00);

COMMIT;
