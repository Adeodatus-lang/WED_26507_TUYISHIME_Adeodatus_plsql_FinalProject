# RwandAir Flight Booking System - 
Phase 1: Problem Statement  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Instructor:** Eric Maniraguha  
**Student:** TUYISHIME Adeodatus  
**Date:** March 27, 2025  
**Institution:** Adventist University of Central Africa  

---

## Problem Definition  
RwandAir faces inefficiencies in flight booking management, including:  
- Overbooking and scheduling conflicts  
- Manual errors in passenger records  
- Delays in ticket processing  

This PL/SQL-based system aims to **automate and optimize** these operations.  

---

## System Context  
**Deployment Scope:**  
- RwandAir offices  
- Airport counters  
- Online booking platforms  

**Key Functions:**  
1. Flight schedule management  
2. Passenger record maintenance  
3. Payment and refund processing  

---

## Target Users  
| User Type | Responsibilities |  
|-----------|------------------|  
| Passengers | Book/manage flights |  
| Airline Staff | Process bookings, update records |  
| Crew | View assigned flight schedules |  
| Finance Team | Handle payments and reporting |  

---

## Project Goals  
✅ **Automate bookings** to reduce human errors  
✅ **Real-time data sync** for flight and passenger records  
✅ **Secure payment processing** with audit trails  

---

## Database Entities (Proposed)  
sql
-- Core Tables:
PASSENGER (Passenger_ID, Name, Passport_No, Contact_Info)
FLIGHT (Flight_ID, Departure_City, Arrival_City, DateTime)
BOOKING (Booking_ID, Passenger_ID, Flight_ID, Seat_No, Status

---


## Business Process Modeling
 

---

## BPMN Model Overview  
**Process:** Flight Booking and Ticket Management  
**Tool Used:** BPMN 2.0 (via draw.io/Lucidchart)
![ diagram](https://github.com/user-attachments/assets/10c433f2-23c6-47f6-91c5-c4cfa630dbcc)
]  

### Key Objectives  
✅ Automate booking workflows to **reduce errors**  
✅ Enable **real-time data synchronization** across departments  
✅ Optimize resource allocation (crew, aircraft)  

---

## Core Entities & Responsibilities  
| Entity | Role |  
|--------|------|  
| **Passenger** | Initiates bookings, makes payments |  
| **Booking System** | Processes reservations, generates tickets |  
| **Payment Gateway** | Secures transactions, validates payments |  
| **Airline Staff** | Manages exceptions/customer support |  
| **Database (PL/SQL)** | Central data repository for all operations |  

---

## ERD
---
![ERD](https://github.com/user-attachments/assets/daaf2fb6-4d12-49b4-8727-eec1efbe5c06)

---

# Phase 3: Logical Model Design  
sql
---

## ER Model Overview  
*Simplified visualization of core entities*

### Core Entities & Attributes  
sql
-- 3NF-Compliant Tables
PASSENGER (
  Passenger_ID PK,
  Name NOT NULL,
  Passport_No UNIQUE NOT NULL,
  Contact,
  Email
);

FLIGHT (
  Flight_ID PK,
  Departure NOT NULL,
  Arrival NOT NULL,
  Date,
  Time,
  Aircraft_ID
);

BOOKING (
  Booking_ID PK,
  Passenger_ID FK → PASSENGER,
  Flight_ID FK → FLIGHT,
  Seat_No,
  Ticket_Status CHECK ('Confirmed', 'Pending', 'Cancelled')
);
---

## phase 4 

---

## Database Setup  
### 1. PDB Creation  
sql
![creation of pluggable database](https://github.com/user-attachments/assets/e384a6c0-572e-490b-ba90-78c2a3e10d78)
![OEM ](https://github.com/user-attachments/assets/30422341-94aa-428f-b065-839407374145)


---

# Phase 5

---
-- Passenger Table
CREATE TABLE Passenger (
    Passenger_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Passport_No VARCHAR2(20) UNIQUE NOT NULL,
    Contact VARCHAR2(15) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL
);

-- Flight Table
CREATE TABLE Flight (
    Flight_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Departure VARCHAR2(100) NOT NULL,
    Arrival VARCHAR2(100) NOT NULL,
    Flight_Date DATE NOT NULL,
    Flight_Time VARCHAR2(10) NOT NULL,
    Aircraft_ID VARCHAR2(20) NOT NULL
);

-- Booking Table
CREATE TABLE Booking (
    Booking_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Passenger_ID NUMBER NOT NULL,
    Flight_ID NUMBER NOT NULL,
    Seat_No VARCHAR2(10) NOT NULL,
    Ticket_Status VARCHAR2(20) CHECK (Ticket_Status IN ('Confirmed', 'Pending', 'Cancelled')) DEFAULT 'Pending',

    CONSTRAINT fk_booking_passenger
        FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID)
        ON DELETE CASCADE,

   CONSTRAINT fk_booking_flight
   FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
   ON DELETE CASCADE
);

-- Payment Table
CREATE TABLE Payment (
    Payment_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Booking_ID NUMBER NOT NULL,
    Amount NUMBER(10,2) CHECK (Amount >= 0) NOT NULL,
    Payment_Status VARCHAR2(20) CHECK (Payment_Status IN ('Paid', 'Refunded', 'Pending')) DEFAULT 'Pending',
    Date_Paid DATE DEFAULT SYSDATE,

   CONSTRAINT fk_payment_booking
   FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
   ON DELETE CASCADE
);

-- Crew Table
CREATE TABLE Crew (
    Crew_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Role VARCHAR2(50) CHECK (Role IN ('Pilot', 'Co-Pilot', 'Flight Attendant', 'Engineer')) NOT NULL,
    Assigned_Flight_ID NUMBER,

   CONSTRAINT fk_crew_flight
   FOREIGN KEY (Assigned_Flight_ID) REFERENCES Flight(Flight_ID)
   ON DELETE SET NULL
);

-- 🇷🇼 **Passenger Table Inserts**

INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Jean Uwimana', 'RW1234567', '0788123456', 'jean.uwimana@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Alice Mukamana', 'RW2345678', '0788345678', 'alice.mukamana@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Eric Niyonzima', 'RW3456789', '0788456789', 'eric.niyonzima@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Claudine Uwamariya', 'RW4567890', '0788567890', 'claudine.uwamariya@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Patrick Nshimiyimana', 'RW5678901', '0788678901', 'patrick.nshimiyimana@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Divine Ingabire', 'RW6789012', '0788789012', 'divine.ingabire@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Samuel Mugisha', 'RW7890123', '0788890123', 'samuel.mugisha@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Esther Uwase', 'RW8901234', '0788901234', 'esther.uwase@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Denis Habimana', 'RW9012345', '0788012345', 'denis.habimana@gmail.com');
INSERT INTO Passenger (Name, Passport_No, Contact, Email) VALUES ('Josiane Mukazayire', 'RW0123456', '0788023456', 'josiane.mukazayire@gmail.com');

-- 🛫 **Flight Table Inserts**

INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Nairobi', TO_DATE('2025-06-10', 'YYYY-MM-DD'), '10:00', 'RWB737');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Johannesburg', TO_DATE('2025-06-11', 'YYYY-MM-DD'), '14:00', 'RWB320');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Dubai', TO_DATE('2025-06-12', 'YYYY-MM-DD'), '21:00', 'RWB777');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Lagos', TO_DATE('2025-06-13', 'YYYY-MM-DD'), '13:30', 'RWBQ400');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Bujumbura', TO_DATE('2025-06-14', 'YYYY-MM-DD'), '09:15', 'RWB737');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Entebbe', TO_DATE('2025-06-15', 'YYYY-MM-DD'), '08:30', 'RWBQ400');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Lusaka', TO_DATE('2025-06-16', 'YYYY-MM-DD'), '15:00', 'RWB320');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Addis Ababa', TO_DATE('2025-06-17', 'YYYY-MM-DD'), '17:45', 'RWB777');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Dar es Salaam', TO_DATE('2025-06-18', 'YYYY-MM-DD'), '12:10', 'RWB737');
INSERT INTO Flight (Departure, Arrival, Flight_Date, Flight_Time, Aircraft_ID) VALUES ('Kigali', 'Accra', TO_DATE('2025-06-19', 'YYYY-MM-DD'), '19:30', 'RWBQ400');

-- 🎟️ **Booking Table Inserts**

INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (1, 1, '12A', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (2, 2, '14B', 'Pending');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (3, 3, '10C', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (4, 4, '22A', 'Cancelled');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (5, 5, '8F', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (6, 6, '9D', 'Pending');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (7, 7, '11E', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (8, 8, '13B', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (9, 9, '15C', 'Confirmed');
INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status) VALUES (10, 10, '7A', 'Pending');


-- 💳 **Payment Table Inserts**

INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (1, 200.00, 'Paid', TO_DATE('2025-06-01', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (2, 250.00, 'Pending', NULL);
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (3, 480.00, 'Paid', TO_DATE('2025-06-02', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (4, 320.00, 'Refunded', TO_DATE('2025-06-03', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (5, 150.00, 'Paid', TO_DATE('2025-06-04', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (6, 120.00, 'Pending', NULL);
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (7, 450.00, 'Paid', TO_DATE('2025-06-05', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (8, 600.00, 'Paid', TO_DATE('2025-06-06', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (9, 300.00, 'Paid', TO_DATE('2025-06-07', 'YYYY-MM-DD'));
INSERT INTO Payment (Booking_ID, Amount, Payment_Status, Date_Paid) VALUES (10, 220.00, 'Pending', NULL);

-- 👨‍✈️ **Crew Table Inserts**

INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Aimable Gatera', 'Pilot', 1);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Solange Nkurunziza', 'Co-Pilot', 2);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Bernard Mugenzi', 'Flight Attendant', 3);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Ange Tuyisenge', 'Engineer', 4);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Claudia Uwase', 'Flight Attendant', 5);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Jean Bosco Habiyambere', 'Pilot', 6);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Alice Uwamahoro', 'Co-Pilot', 7);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Elysee Mugiraneza', 'Flight Attendant', 8);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Sandrine Isaro', 'Engineer', 9);
INSERT INTO Crew (Name, Role, Assigned_Flight_ID) VALUES ('Patrick Ruzima', 'Pilot', 10);



##Phase 6
---
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

## Phase 7
--
-- Create holiday table
CREATE TABLE Holiday (
    Holiday_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Holiday_Name VARCHAR2(100) NOT NULL,
    Holiday_Date DATE NOT NULL,
    Description VARCHAR2(200)
);

-- Insert sample holidays for the upcoming month (June 2025)
INSERT INTO Holiday (Holiday_Name, Holiday_Date, Description) 
VALUES ('Liberation Day', TO_DATE('2025-07-04', 'YYYY-MM-DD'), 'Rwanda Liberation Day');

INSERT INTO Holiday (Holiday_Name, Holiday_Date, Description) 
VALUES ('National Heroes Day', TO_DATE('2025-07-01', 'YYYY-MM-DD'), 'Rwanda National Heroes Day');


-- Create audit table
CREATE TABLE Booking_Audit (
    Audit_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username VARCHAR2(100) NOT NULL,
    Action_Date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    Table_Name VARCHAR2(50) NOT NULL,
    Operation VARCHAR2(20) NOT NULL,
    Record_ID NUMBER,
    Old_Value VARCHAR2(4000),
    New_Value VARCHAR2(4000),
    Status VARCHAR2(20) NOT NULL,
    Message VARCHAR2(500)
);

-- Restriction Trigger for Weekdays/Holidays

CREATE OR REPLACE TRIGGER restrict_weekday_operations
BEFORE INSERT OR UPDATE OR DELETE ON Booking
FOR EACH ROW
DECLARE
    v_is_holiday NUMBER;
    v_day_of_week VARCHAR2(20);
    v_error_message VARCHAR2(200);
BEGIN
    -- Get day of week (Sunday = 1, Saturday = 7)
    v_day_of_week := TO_CHAR(SYSDATE, 'D');
    
   -- Check if today is a holiday in the upcoming month
    SELECT COUNT(*)
    INTO v_is_holiday
    FROM Holiday
    WHERE Holiday_Date = TRUNC(SYSDATE)
    AND Holiday_Date BETWEEN TRUNC(SYSDATE) AND ADD_MONTHS(TRUNC(SYSDATE), 1);
    
   -- Check if today is a weekday (Monday to Friday) or holiday
    IF (v_day_of_week BETWEEN '2' AND '6') OR v_is_holiday > 0 THEN
        -- Prepare error message
        IF v_is_holiday > 0 THEN
            SELECT 'Today is holiday: ' || Holiday_Name
            INTO v_error_message
            FROM Holiday
            WHERE Holiday_Date = TRUNC(SYSDATE)
            AND ROWNUM = 1;
        ELSE
            v_error_message := 'Today is a weekday (Monday to Friday)';
        END IF;
        
   -- Log the attempt
        INSERT INTO Booking_Audit (
            Username, 
            Table_Name, 
            Operation, 
            Record_ID, 
            Status, 
            Message
        ) VALUES (
            USER, 
            'BOOKING', 
            CASE 
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            :NEW.Booking_ID,
            'DENIED',
            'Operation blocked: ' || v_error_message
        );
        COMMIT;
        
   -- Raise application error
        RAISE_APPLICATION_ERROR(-20001, 
            'Data manipulation not allowed on weekdays or holidays. ' || v_error_message);
    END IF;
    
   -- Log successful operations if not restricted
    IF (v_day_of_week NOT BETWEEN '2' AND '6') AND v_is_holiday = 0 THEN
        INSERT INTO Booking_Audit (
            Username, 
            Table_Name, 
            Operation, 
            Record_ID, 
            Status, 
            Message
        ) VALUES (
            USER, 
            'BOOKING', 
            CASE 
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            :NEW.Booking_ID,
            'ALLOWED',
            'Operation completed successfully'
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Log any errors
        INSERT INTO Booking_Audit (
            Username, 
            Table_Name, 
            Operation, 
            Status, 
            Message
        ) VALUES (
            USER, 
            'BOOKING', 
            CASE 
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            'ERROR',
            'Trigger error: ' || SQLERRM
        );
        COMMIT;
        RAISE;
END restrict_weekday_operations;
/

-- Payment Audit Trigger

CREATE OR REPLACE TRIGGER audit_payment_changes
AFTER INSERT OR UPDATE OR DELETE ON Payment
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(20);
    v_record_id NUMBER;
BEGIN
    -- Determine operation type
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_record_id := :NEW.Payment_ID;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_record_id := :NEW.Payment_ID;
    ELSE
        v_operation := 'DELETE';
        v_record_id := :OLD.Payment_ID;
    END IF;
    
   -- Log the operation
    INSERT INTO Booking_Audit (
        Username,
        Table_Name,
        Operation,
        Record_ID,
        Old_Value,
        New_Value,
        Status,
        Message
    ) VALUES (
        USER,
        'PAYMENT',
        v_operation,
        v_record_id,
        CASE 
            WHEN UPDATING OR DELETING THEN 
                'Booking_ID=' || :OLD.Booking_ID || 
                ', Amount=' || :OLD.Amount || 
                ', Status=' || :OLD.Payment_Status || 
                ', Date=' || TO_CHAR(:OLD.Date_Paid, 'YYYY-MM-DD')
            ELSE NULL
        END,
        CASE 
            WHEN INSERTING OR UPDATING THEN 
                'Booking_ID=' || :NEW.Booking_ID || 
                ', Amount=' || :NEW.Amount || 
                ', Status=' || :NEW.Payment_Status || 
                ', Date=' || TO_CHAR(:NEW.Date_Paid, 'YYYY-MM-DD')
            ELSE NULL
        END,
        'ALLOWED',
        'Payment record ' || v_operation || ' operation'
    );
EXCEPTION
    WHEN OTHERS THEN
        -- Log trigger errors without stopping the operation
        INSERT INTO Booking_Audit (
            Username,
            Table_Name,
            Operation,
            Status,
            Message
        ) VALUES (
            USER,
            'PAYMENT',
            v_operation,
            'ERROR',
            'Audit trigger error: ' || SQLERRM
        );
        COMMIT;
END audit_payment_changes;
/

-- 5. Auditing Package

CREATE OR REPLACE PACKAGE audit_management_pkg AS
    -- Procedure to generate audit report
    PROCEDURE generate_audit_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_table_name IN VARCHAR2 DEFAULT NULL,
        p_status IN VARCHAR2 DEFAULT NULL
    );
    
   -- Function to check if operation is allowed
    FUNCTION is_operation_allowed RETURN BOOLEAN;
    
   -- Procedure to purge old audit records
    PROCEDURE purge_audit_records(
        p_older_than_days IN NUMBER DEFAULT 90
    );
END audit_management_pkg;
/

CREATE OR REPLACE PACKAGE BODY audit_management_pkg AS
    PROCEDURE generate_audit_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_table_name IN VARCHAR2 DEFAULT NULL,
        p_status IN VARCHAR2 DEFAULT NULL
    ) AS
        v_start_date DATE := NVL(p_start_date, TRUNC(SYSDATE) - 30);
        v_end_date DATE := NVL(p_end_date, TRUNC(SYSDATE) + 1);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Audit Report');
        DBMS_OUTPUT.PUT_LINE('Date Range: ' || TO_CHAR(v_start_date, 'YYYY-MM-DD') || 
                          ' to ' || TO_CHAR(v_end_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Table: ' || NVL(p_table_name, 'ALL'));
        DBMS_OUTPUT.PUT_LINE('Status: ' || NVL(p_status, 'ALL'));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 100, '-'));
        
   FOR audit_rec IN (
            SELECT 
                Username,
                Table_Name,
                Operation,
                TO_CHAR(Action_Date, 'YYYY-MM-DD HH24:MI:SS') AS Action_Time,
                Record_ID,
                Status,
                Message
            FROM Booking_Audit
            WHERE Action_Date BETWEEN v_start_date AND v_end_date
            AND (p_table_name IS NULL OR Table_Name = p_table_name)
            AND (p_status IS NULL OR Status = p_status)
            ORDER BY Action_Date DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'User: ' || RPAD(audit_rec.Username, 15) ||
                ' Table: ' || RPAD(audit_rec.Table_Name, 10) ||
                ' Operation: ' || RPAD(audit_rec.Operation, 10) ||
                ' On: ' || audit_rec.Action_Time
            );
            DBMS_OUTPUT.PUT_LINE(
                'Record ID: ' || NVL(TO_CHAR(audit_rec.Record_ID), 'N/A') ||
                ' Status: ' || audit_rec.Status ||
                ' Message: ' || audit_rec.Message
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 100, '-'));
        END LOOP;
    END generate_audit_report;
    
   FUNCTION is_operation_allowed RETURN BOOLEAN IS
        v_is_holiday NUMBER;
        v_day_of_week VARCHAR2(20);
    BEGIN
        -- Get day of week (Sunday = 1, Saturday = 7)
        v_day_of_week := TO_CHAR(SYSDATE, 'D');
        
   -- Check if today is a holiday in the upcoming month
        SELECT COUNT(*)
        INTO v_is_holiday
        FROM Holiday
        WHERE Holiday_Date = TRUNC(SYSDATE)
        AND Holiday_Date BETWEEN TRUNC(SYSDATE) AND ADD_MONTHS(TRUNC(SYSDATE), 1);
        
   -- Return TRUE if it's weekend and not holiday
        RETURN (v_day_of_week NOT BETWEEN '2' AND '6') AND v_is_holiday = 0;
    END is_operation_allowed;
    
   PROCEDURE purge_audit_records(
        p_older_than_days IN NUMBER DEFAULT 90
    ) AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM Booking_Audit
        WHERE Action_Date < TRUNC(SYSDATE) - p_older_than_days;
        
   DELETE FROM Booking_Audit
        WHERE Action_Date < TRUNC(SYSDATE) - p_older_than_days;
       
   COMMIT;
        
   DBMS_OUTPUT.PUT_LINE('Purged ' || v_count || ' audit records older than ' || 
                            p_older_than_days || ' days');
        
   -- Log the purge operation
        INSERT INTO Booking_Audit (
            Username,
            Table_Name,
            Operation,
            Status,
            Message
        ) VALUES (
            USER,
            'AUDIT',
            'PURGE',
            'ALLOWED',
            'Purged ' || v_count || ' records older than ' || p_older_than_days || ' days'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error purging audit records: ' || SQLERRM);
    END purge_audit_records;
END audit_management_pkg;
/

-- 6. Testing the Implementation

-- Test 1: Try to modify bookings on a weekday (should fail)
-- Note: Run this on a weekday to see the restriction in action
BEGIN
    -- This should fail if run Monday-Friday
    UPDATE Booking
    SET Ticket_Status = 'Confirmed'
    WHERE Booking_ID = 1;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- Test 2: Check audit entries for the failed attempt
BEGIN
    audit_management_pkg.generate_audit_report(
        p_start_date => TRUNC(SYSDATE),
        p_table_name => 'BOOKING',
        p_status => 'DENIED'
    );
END;
/

-- Test 3: Test payment audit trigger
BEGIN
    -- This will be audited
    UPDATE Payment
    SET Payment_Status = 'Paid',
        Date_Paid = SYSDATE
    WHERE Booking_ID = 2;
    
COMMIT;
END;
/

-- Test 4: View all audit entries
BEGIN
    audit_management_pkg.generate_audit_report;
END;
/

-- Test 5: Test is_operation_allowed function
DECLARE
    v_allowed BOOLEAN;
BEGIN
    v_allowed := audit_management_pkg.is_operation_allowed;
    DBMS_OUTPUT.PUT_LINE('Operation allowed: ' || 
                        CASE WHEN v_allowed THEN 'YES' ELSE 'NO' END);
END;
/

-- Test 6: Test holiday restriction
-- First, add a holiday for today
BEGIN
    INSERT INTO Holiday (Holiday_Name, Holiday_Date, Description)
    VALUES ('Test Holiday', TRUNC(SYSDATE), 'Testing holiday restriction');
    
 COMMIT;
    
 -- Now try to insert a booking (should fail)
    BEGIN
        INSERT INTO Booking (Passenger_ID, Flight_ID, Seat_No, Ticket_Status)
        VALUES (1, 1, '99Z', 'Pending');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
    END;
    
   -- Cleanup
    DELETE FROM Holiday WHERE Holiday_Date = TRUNC(SYSDATE);
    COMMIT;
END;
/

-- Test 7: Purge old audit records (simulate by adding old record)
BEGIN
    -- Insert an old audit record
    INSERT INTO Booking_Audit (
        Username, 
        Table_Name, 
        Operation, 
        Status, 
        Message,
        Action_Date
    ) VALUES (
        USER, 
        'TEST', 
        'INSERT', 
        'ALLOWED', 
        'Old test record',
        SYSDATE - 100
    );
    
   COMMIT;
    
  -- Purge records older than 90 days
  audit_management_pkg.purge_audit_records(90);
END;
/
    analyze_booking_trends();
END;
/
### THANK YOU!
