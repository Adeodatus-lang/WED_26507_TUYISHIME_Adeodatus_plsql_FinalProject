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