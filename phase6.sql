-- 1. Database Operations (DML and DDL)

-- Procedure to add a new passenger
CREATE OR REPLACE PROCEDURE add_passenger(
    p_name IN VARCHAR2,
    p_passport_no IN VARCHAR2,
    p_contact IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO Passenger (Name, Passport_No, Contact, Email)
    VALUES (p_name, p_passport_no, p_contact, p_email);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Passenger added successfully');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error adding passenger: ' || SQLERRM);
END add_passenger;
/

-- Procedure to book a flight
CREATE OR REPLACE PROCEDURE book_flight(
    p_passenger_id IN NUMBER,
    p_flight_id IN NUMBER,
    p_seat_no IN VARCHAR2,
    p_ticket_status IN VARCHAR2 DEFAULT 'Pending'
) AS
BEGIN
    INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status)
    VALUES (p_passenger_id, p_flight_id, p_seat_no, p_ticket_status);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Flight booked successfully');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error booking flight: ' || SQLERRM);
END book_flight;
/

-- Procedure to update payment status
CREATE OR REPLACE PROCEDURE update_payment_status(
    p_booking_id IN NUMBER,
    p_payment_status IN VARCHAR2
) AS
BEGIN
    UPDATE Payment
    SET Payment_Status = p_payment_status,
        Date_Paid = CASE WHEN p_payment_status = 'Paid' THEN SYSDATE ELSE Date_Paid END
    WHERE Booking_ID = p_booking_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Payment status updated successfully');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error updating payment status: ' || SQLERRM);
END update_payment_status;
/

-- 2. Functions for Data Retrieval

-- Function to get passenger details
CREATE OR REPLACE FUNCTION get_passenger_details(
    p_passenger_id IN NUMBER
) RETURN SYS_REFCURSOR
AS
    passenger_cursor SYS_REFCURSOR;
BEGIN
    OPEN passenger_cursor FOR
        SELECT * FROM Passenger
        WHERE Passenger_ID = p_passenger_id;
    
    RETURN passenger_cursor;
END get_passenger_details;
/

-- Function to count bookings by status
CREATE OR REPLACE FUNCTION count_bookings_by_status(
    p_status IN VARCHAR2
) RETURN NUMBER
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Booking
    WHERE Ticket_Status = p_status;
    
    RETURN v_count;
END count_bookings_by_status;
/

-- Function to calculate total revenue
CREATE OR REPLACE FUNCTION calculate_total_revenue
RETURN NUMBER
AS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(Amount)
    INTO v_total
    FROM Payment
    WHERE Payment_Status = 'Paid';
    
    RETURN NVL(v_total, 0);
END calculate_total_revenue;
/

-- 3. Package Implementation

CREATE OR REPLACE PACKAGE flight_management_pkg AS
    -- Procedure to add a new flight
    PROCEDURE add_flight(
        p_departure IN VARCHAR2,
        p_arrival IN VARCHAR2,
        p_flight_date IN DATE,
        p_flight_time IN VARCHAR2,
        p_aircraft_id IN VARCHAR2
    );
    
    -- Function to get available seats for a flight
    FUNCTION get_available_seats(
        p_flight_id IN NUMBER
    ) RETURN SYS_REFCURSOR;
    
    -- Procedure to assign crew to flight
    PROCEDURE assign_crew_to_flight(
        p_crew_id IN NUMBER,
        p_flight_id IN NUMBER
    );
    
    -- Function to get flight details with crew
    FUNCTION get_flight_details_with_crew(
        p_flight_id IN NUMBER
    ) RETURN SYS_REFCURSOR;
    
    -- Procedure to cancel booking with refund
    PROCEDURE cancel_booking_with_refund(
        p_booking_id IN NUMBER
    );
END flight_management_pkg;
/

CREATE OR REPLACE PACKAGE BODY flight_management_pkg AS
    PROCEDURE add_flight(
        p_departure IN VARCHAR2,
        p_arrival IN VARCHAR2,
        p_flight_date IN DATE,
        p_flight_time IN VARCHAR2,
        p_aircraft_id IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID)
        VALUES (p_departure, p_arrival, p_flight_date, p_flight_time, p_aircraft_id);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Flight added successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error adding flight: ' || SQLERRM);
    END add_flight;
    
    FUNCTION get_available_seats(
        p_flight_id IN NUMBER
    ) RETURN SYS_REFCURSOR
    AS
        seats_cursor SYS_REFCURSOR;
    BEGIN
        -- Here we're just showing booked seats and assuming others are available
        OPEN seats_cursor FOR
            SELECT Seat_No FROM Booking
            WHERE Flight_ID = p_flight_id;
            
        RETURN seats_cursor;
    END get_available_seats;
    
    PROCEDURE assign_crew_to_flight(
        p_crew_id IN NUMBER,
        p_flight_id IN NUMBER
    ) AS
    BEGIN
        UPDATE Crew
        SET Assigned_Flight_ID = p_flight_id
        WHERE Crew_ID = p_crew_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Crew assigned to flight successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error assigning crew: ' || SQLERRM);
    END assign_crew_to_flight;
    
    FUNCTION get_flight_details_with_crew(
        p_flight_id IN NUMBER
    ) RETURN SYS_REFCURSOR
    AS
        flight_cursor SYS_REFCURSOR;
    BEGIN
        OPEN flight_cursor FOR
            SELECT f.*, c.Name AS Crew_Name, c.Role AS Crew_Role
            FROM Flight f
            LEFT JOIN Crew c ON f.Flight_ID = c.Assigned_Flight_ID
            WHERE f.Flight_ID = p_flight_id;
            
        RETURN flight_cursor;
    END get_flight_details_with_crew;
    
    PROCEDURE cancel_booking_with_refund(
        p_booking_id IN NUMBER
    ) AS
        v_payment_status VARCHAR2(20);
        v_amount NUMBER;
    BEGIN
        -- Check payment status
        SELECT Payment_Status, Amount
        INTO v_payment_status, v_amount
        FROM Payment
        WHERE Booking_ID = p_booking_id;
        
        -- Update booking status
        UPDATE Booking
        SET Ticket_Status = 'Cancelled'
        WHERE Booking_ID = p_booking_id;
        
        -- Process refund if paid
        IF v_payment_status = 'Paid' THEN
            UPDATE Payment
            SET Payment_Status = 'Refunded',
                Date_Paid = SYSDATE
            WHERE Booking_ID = p_booking_id;
            
            DBMS_OUTPUT.PUT_LINE('Booking cancelled and amount ' || v_amount || ' refunded');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Booking cancelled (no refund processed)');
        END IF;
        
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Booking not found');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error cancelling booking: ' || SQLERRM);
    END cancel_booking_with_refund;
END flight_management_pkg;
/

-- 4. Window Functions Example

-- Procedure to analyze booking trends
CREATE OR REPLACE PROCEDURE analyze_booking_trends
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Booking Trends Analysis:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    
    FOR trend_rec IN (
        SELECT 
            Flight_ID,
            COUNT(*) AS total_bookings,
            SUM(CASE WHEN Ticket_Status = 'Confirmed' THEN 1 ELSE 0 END) AS confirmed_bookings,
            ROUND(SUM(CASE WHEN Ticket_Status = 'Confirmed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS confirmation_rate,
            RANK() OVER (ORDER BY COUNT(*) DESC) AS popularity_rank
        FROM Booking
        GROUP BY Flight_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Flight ID: ' || trend_rec.Flight_ID);
        DBMS_OUTPUT.PUT_LINE('Total Bookings: ' || trend_rec.total_bookings);
        DBMS_OUTPUT.PUT_LINE('Confirmed Bookings: ' || trend_rec.confirmed_bookings);
        DBMS_OUTPUT.PUT_LINE('Confirmation Rate: ' || trend_rec.confirmation_rate || '%');
        DBMS_OUTPUT.PUT_LINE('Popularity Rank: ' || trend_rec.popularity_rank);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
    END LOOP;
END analyze_booking_trends;
/

-- 5. Testing the Implementation

-- Test add_passenger procedure
BEGIN
    add_passenger('Test Passenger', 'RW9876543', '0788998877', 'test.passenger@gmail.com');
END;
/

-- Test book_flight procedure
BEGIN
    book_flight(1, 2, '15D', 'Confirmed');
END;
/

-- Test update_payment_status procedure
BEGIN
    update_payment_status(2, 'Paid');
END;
/

-- Test get_passenger_details function
DECLARE
    passenger_cursor SYS_REFCURSOR;
    passenger_rec Passenger%ROWTYPE;
BEGIN
    passenger_cursor := get_passenger_details(1);
    LOOP
        FETCH passenger_cursor INTO passenger_rec;
        EXIT WHEN passenger_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Passenger: ' || passenger_rec.Name || ', Email: ' || passenger_rec.Email);
    END LOOP;
    CLOSE passenger_cursor;
END;
/

-- Test count_bookings_by_status function
DECLARE
    v_confirmed_count NUMBER;
BEGIN
    v_confirmed_count := count_bookings_by_status('Confirmed');
    DBMS_OUTPUT.PUT_LINE('Confirmed bookings count: ' || v_confirmed_count);
END;
/

-- Test calculate_total_revenue function
DECLARE
    v_total_revenue NUMBER;
BEGIN
    v_total_revenue := calculate_total_revenue();
    DBMS_OUTPUT.PUT_LINE('Total revenue: $' || v_total_revenue);
END;
/

-- Test flight_management_pkg package
BEGIN
    -- Add a new flight
    flight_management_pkg.add_flight('Kigali', 'Brussels', TO_DATE('2025-06-20', 'YYYY-MM-DD'), '08:00', 'RWB787');
    
    -- Assign crew to flight
    flight_management_pkg.assign_crew_to_flight(1, 11);
    
    -- Cancel a booking with refund
    flight_management_pkg.cancel_booking_with_refund(1);
END;
/

-- Test analyze_booking_trends procedure
BEGIN
    analyze_booking_trends();
END;
/
