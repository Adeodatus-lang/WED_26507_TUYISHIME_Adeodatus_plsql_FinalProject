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
