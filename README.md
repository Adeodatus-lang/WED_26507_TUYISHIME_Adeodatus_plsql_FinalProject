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
