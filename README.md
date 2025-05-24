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
```sql
-- Core Tables:
PASSENGER (Passenger_ID, Name, Passport_No, Contact_Info)
FLIGHT (Flight_ID, Departure_City, Arrival_City, DateTime)
BOOKING (Booking_ID, Passenger_ID, Flight_ID, Seat_No, Status)

#  Phase 2: Business Process Modeling  

---

## BPMN Model Overview  
**Process:** Flight Booking and Ticket Management  
**Tool Used:** BPMN 2.0 (via draw.io/Lucidchart)
![ERD](https://github.com/user-attachments/assets/daaf2fb6-4d12-49b4-8727-eec1efbe5c06)
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

## Swimlane Structure  
```plaintext
1. Passenger → Searches flights → Selects option → Pays  
2. Booking System → Checks availability → Registers booking → Issues ticket  
3. Payment Gateway → Processes payment → Confirms status  
4. Airline Staff → Handles exceptions (e.g., overbooking)

![ diagram](https://github.com/user-attachments/assets/10c433f2-23c6-47f6-91c5-c4cfa630dbcc)

