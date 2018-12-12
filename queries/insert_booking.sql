-- <--------------------------------------------------------------------------
--   Linguaggi e Tecnologie per il Web - Progetto
--   Stored Procedure to add bookings
--   Paolo Lucchesi, Matteo Giaccone
--  -------------------------------------------------------------------------->


-- Add a new booking and return the newly created row
BEGIN;
CREATE FUNCTION addBooking(_hotel varchar, _room_type varchar, _arrival date,
	_departure date, OUT inserted record) AS $$

DECLARE
	_id integer;
	_room smallint;
	_price numeric;

BEGIN
	-- Get an ID for the new prenotation
	SELECT nextval INTO _id FROM nextval('booking_id');

	-- Obtain the first free room
	-- TODO: Make sure that there are no "starving" rooms. Insert a trigger to
	--	update rooms with the date of their last departure
	SELECT num INTO _room FROM room WHERE (hotel = _hotel AND type = _room_type)
	EXCEPT
	SELECT room FROM booking WHERE (hotel = _hotel AND room_type = _room_type
		AND departure >= _arrival)
	LIMIT 1;

	IF _room IS NULL THEN
		RAISE EXCEPTION 'Rooms of type "%" are busy', _room_type;
	END IF;

	-- Calculate total price
	_price := ((_departure - _arrival) *
		(SELECT price FROM room WHERE room.type = _room_type LIMIT 1) + 1)::numeric;

	-- Actually insert the new booking (all should be fine now, no errors expected)
	INSERT INTO booking VALUES (
		_id,
		_hotel,
		_room_type,
		_room,
		_arrival,
		_departure,
		_price
	) RETURNING * INTO inserted;
END;
$$ LANGUAGE plpgsql;
COMMIT;
