-- SECTION 0: DROP & CREATE DATABASE

DROP DATABASE IF EXISTS eHotels;
CREATE DATABASE eHotels;
USE eHotels;

-- SECTION 1: DATABASE IMPLEMENTATION (Schema Creation)

-- 1. Users Table for Role-Based Access
CREATE TABLE Users (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password_Hash VARCHAR(255) NOT NULL,
    Role ENUM('Customer', 'Employee') NOT NULL
);

-- 2. Employee Table
CREATE TABLE Employee (
    RS_Number INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Social_Security_Number VARCHAR(15) UNIQUE,
    Address VARCHAR(100),
    User_ID INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);

-- 3. Customer Table (supports various ID types)
CREATE TABLE Customer (
    RS_Number INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Identification_Number VARCHAR(15) UNIQUE,
    ID_Type ENUM('SSN', 'SIN', 'Driving Licence') NOT NULL,
    First_Registration DATE,
    Address VARCHAR(100),
    User_ID INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);

-- 4. Hotel Group Table (Hotel Chains)
CREATE TABLE Hotel_Group (
    Hotel_Group_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Number_of_Hotels INT NOT NULL,
    Phone_Number VARCHAR(15),
    Email_Address VARCHAR(50),
    Address VARCHAR(100)
);

-- 5. Hotel Table (each hotel belongs to a chain and must have a manager)
CREATE TABLE Hotel (
    Hotel_ID INT PRIMARY KEY,
    Hotel_Group_ID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Phone_Number VARCHAR(15),
    Email_Address VARCHAR(50),
    Stars INT CHECK (Stars BETWEEN 1 AND 5),
    Address VARCHAR(100),
    Total_Rooms INT CHECK (Total_Rooms > 0),
    Category VARCHAR(50),
    Manager_RS_Number INT NOT NULL,
    FOREIGN KEY (Hotel_Group_ID) REFERENCES Hotel_Group(Hotel_Group_ID) ON DELETE CASCADE,
    FOREIGN KEY (Manager_RS_Number) REFERENCES Employee(RS_Number) ON DELETE CASCADE
);

-- 6. Hotel Room Table (Weak Entity with Booking Status)
CREATE TABLE Hotel_Room (
    Room_ID INT,
    Hotel_ID INT,
    Price DECIMAL(10,2),
    Capacity INT CHECK (Capacity > 0),
    View VARCHAR(30),
    Expandable BOOLEAN,
    Repairs_Need BOOLEAN,
    Amenities TEXT,
    Availability_Status ENUM('Available', 'Booked', 'Rented') DEFAULT 'Available',
    PRIMARY KEY (Room_ID, Hotel_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID) ON DELETE CASCADE
);

-- 7. Works Relationship: Employee working at a hotel in a specific role/position
CREATE TABLE Works (
    Employee_RS_Number INT,
    Hotel_ID INT,
    Start_Date DATE,
    Finish_Date DATE,
    Position VARCHAR(50),
    PRIMARY KEY (Employee_RS_Number, Hotel_ID, Start_Date),
    FOREIGN KEY (Employee_RS_Number) REFERENCES Employee(RS_Number) ON DELETE CASCADE,
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID) ON DELETE CASCADE
);

-- 8. Reserved Relationship: Room booking by a customer
CREATE TABLE Reserved (
    Customer_RS_Number INT,
    Room_ID INT,
    Hotel_ID INT,
    Start_Date DATE,
    Finish_Date DATE,
    Paid BOOLEAN,
    PRIMARY KEY (Customer_RS_Number, Room_ID, Hotel_ID, Start_Date),
    FOREIGN KEY (Customer_RS_Number) REFERENCES Customer(RS_Number) ON DELETE CASCADE,
    FOREIGN KEY (Room_ID, Hotel_ID) REFERENCES Hotel_Room(Room_ID, Hotel_ID) ON DELETE CASCADE
);

-- 9. Rents Relationship: Room renting by a customer (with direct room reference)
CREATE TABLE Rents (
    Customer_RS_Number INT,
    Employee_RS_Number INT,
    Room_ID INT,
    Hotel_ID INT,
    Start_Date DATE,
    Finish_Date DATE,
    PRIMARY KEY (Customer_RS_Number, Employee_RS_Number, Room_ID, Hotel_ID, Start_Date),
    FOREIGN KEY (Customer_RS_Number) REFERENCES Customer(RS_Number) ON DELETE CASCADE,
    FOREIGN KEY (Employee_RS_Number) REFERENCES Employee(RS_Number) ON DELETE CASCADE,
    FOREIGN KEY (Room_ID, Hotel_ID) REFERENCES Hotel_Room(Room_ID, Hotel_ID) ON DELETE CASCADE
);

-- 10. Payment Transaction Table (no need to archive payments)
CREATE TABLE Payment_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Payment_Amount DECIMAL(10,2) CHECK (Payment_Amount >= 0),
    Payment_Method VARCHAR(50),
    Rents_Customer_RS INT,
    Rents_Employee_RS INT,
    Rents_Room_ID INT,
    Rents_Hotel_ID INT,
    Rents_Start_Date DATE,
    FOREIGN KEY (Rents_Customer_RS, Rents_Employee_RS, Rents_Room_ID, Rents_Hotel_ID, Rents_Start_Date)
        REFERENCES Rents(Customer_RS_Number, Employee_RS_Number, Room_ID, Hotel_ID, Start_Date) ON DELETE CASCADE
);

-- 11. Booking Archive Table (preserves history of bookings/rentings)
CREATE TABLE Archive_Reserved (
    Customer_RS_Number INT,
    Room_ID INT,
    Hotel_ID INT,
    Start_Date DATE,
    Finish_Date DATE,
    Paid BOOLEAN,
    Archive_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Customer_RS_Number, Room_ID, Hotel_ID, Start_Date)
);

-- 12. TRIGGERS: Auto-update Availability when Booking or Renting
DELIMITER $$
CREATE TRIGGER update_room_availability 
AFTER INSERT ON Reserved
FOR EACH ROW
BEGIN
    UPDATE Hotel_Room
    SET Availability_Status = 'Booked'
    WHERE Room_ID = NEW.Room_ID AND Hotel_ID = NEW.Hotel_ID;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_room_rented 
AFTER INSERT ON Rents
FOR EACH ROW
BEGIN
    UPDATE Hotel_Room
    SET Availability_Status = 'Rented'
    WHERE Room_ID = NEW.Room_ID AND Hotel_ID = NEW.Hotel_ID;
END $$
DELIMITER ;

-- 13. INDEXES for performance and quick lookup
CREATE INDEX idx_hotel_chain ON Hotel(Hotel_Group_ID);
CREATE INDEX idx_room_price_capacity ON Hotel_Room(Price, Capacity);
CREATE INDEX idx_customer_id ON Customer(Identification_Number);

-- 14. VIEWS for UI Aggregated Data
CREATE VIEW Available_Rooms_Per_Area AS
SELECT H.Address, COUNT(*) AS Available_Rooms
FROM Hotel H 
JOIN Hotel_Room HR ON H.Hotel_ID = HR.Hotel_ID
WHERE HR.Availability_Status = 'Available'
GROUP BY H.Address;

CREATE VIEW Room_Capacity_Aggregate AS
SELECT H.Hotel_ID, SUM(HR.Capacity) AS Total_Capacity
FROM Hotel H 
JOIN Hotel_Room HR ON H.Hotel_ID = HR.Hotel_ID
GROUP BY H.Hotel_ID;

-- SECTION 2: DATABASE POPULATION (Ensure Query #4 Can Execute)

-- 2a. Insert Manager Users & Employee Records (One per Hotel Chain)
INSERT INTO Users (Email, Password_Hash, Role) VALUES 
('alice.tremblay@fairmont.ca', 'hash1', 'Employee'),
('bob.martin@fourseasons.ca', 'hash2', 'Employee'),
('carol.dubois@deltahotels.ca', 'hash3', 'Employee'),
('david.chen@sandmanhotels.ca', 'hash4', 'Employee'),
('eve.oconnor@holidayinn.ca', 'hash5', 'Employee');

INSERT INTO Employee (RS_Number, First_Name, Last_Name, Social_Security_Number, Address, User_ID)
VALUES 
(101, 'Alice', 'Tremblay', '111-11-1111', '100 Place Ville Marie, Montreal, QC', 1),
(102, 'Bob', 'Martin', '222-22-2222', '1 King St W, Toronto, ON', 2),
(103, 'Carol', 'Dubois', '333-33-3333', '999 Robson St, Vancouver, BC', 3),
(104, 'David', 'Chen', '444-44-4444', '200 8th Ave SW, Calgary, AB', 4),
(105, 'Eve', 'O''Connor', '555-55-5555', '50 Sparks St, Ottawa, ON', 5);

-- 2b. Insert a Sample Customer (for testing reservations/rentals)
INSERT INTO Users (Email, Password_Hash, Role) VALUES ('james.smith@rogers.ca', 'custHash1', 'Customer');
INSERT INTO Customer (RS_Number, First_Name, Last_Name, Identification_Number, ID_Type, First_Registration, Address, User_ID)
VALUES (201, 'James', 'Smith', '666-66-6666', 'SIN', '2025-01-01', '123 Bloor St, Toronto, ON', 6);

-- 2c. Insert Hotel Chains (5 chains) with Canadian details.
INSERT INTO Hotel_Group (Hotel_Group_ID, Name, Number_of_Hotels, Phone_Number, Email_Address, Address)
VALUES
(1, 'Fairmont Hotels', 8, '514-111-1111', 'info@fairmont.ca', '1 Fairmont Way, Montreal, QC'),
(2, 'Four Seasons', 8, '416-222-2222', 'info@fourseasons.ca', '2 Four Seasons Blvd, Toronto, ON'),
(3, 'Delta Hotels', 8, '604-333-3333', 'info@deltahotels.ca', '3 Delta Rd, Vancouver, BC'),
(4, 'Sandman Hotels', 8, '403-444-4444', 'info@sandmanhotels.ca', '4 Sandman Pkwy, Calgary, AB'),
(5, 'Holiday Inn', 8, '613-555-5555', 'info@holidayinn.ca', '5 Holiday Inn Ct, Ottawa, ON');

-- 2d. Insert Hotels for Each Chain (8 hotels per chain, with at least 3 categories and at least 2 hotels sharing the same area)
-- For Fairmont Hotels (Chain 1, Manager 101)
INSERT INTO Hotel (Hotel_ID, Hotel_Group_ID, Name, Phone_Number, Email_Address, Stars, Address, Total_Rooms, Category, Manager_RS_Number)
VALUES 
(1001, 1, 'Fairmont The Queen Elizabeth', '514-111-1111', 'queene@fairmont.ca', 5, 'Downtown Montreal', 50, 'Luxury', 101),
(1002, 1, 'Fairmont Royal York', '514-111-1112', 'royaly@fairmont.ca', 4, 'Downtown Montreal', 50, 'Standard', 101),
(1003, 1, 'Fairmont Delta', '514-111-1113', 'delta@fairmont.ca', 3, 'Uptown Montreal', 50, 'Budget', 101),
(1004, 1, 'Fairmont Le Château', '514-111-1114', 'chateau@fairmont.ca', 5, 'Suburban Montreal', 50, 'Luxury', 101),
(1005, 1, 'Fairmont St. James', '514-111-1115', 'stjames@fairmont.ca', 4, 'Midtown Montreal', 50, 'Standard', 101),
(1006, 1, 'Fairmont Concordia', '514-111-1116', 'concordia@fairmont.ca', 3, 'Uptown Montreal', 50, 'Budget', 101),
(1007, 1, 'Fairmont Centre', '514-111-1117', 'centre@fairmont.ca', 5, 'Downtown Montreal', 50, 'Luxury', 101),
(1008, 1, 'Fairmont Westmount', '514-111-1118', 'westmount@fairmont.ca', 4, 'Suburban Montreal', 50, 'Standard', 101);

-- For Four Seasons (Chain 2, Manager 102)
INSERT INTO Hotel (Hotel_ID, Hotel_Group_ID, Name, Phone_Number, Email_Address, Stars, Address, Total_Rooms, Category, Manager_RS_Number)
VALUES 
(2001, 2, 'Four Seasons Toronto 1', '416-222-2222', 'fs1@fourseasons.ca', 4, 'Central Toronto', 60, 'Luxury', 102),
(2002, 2, 'Four Seasons Toronto 2', '416-222-2223', 'fs2@fourseasons.ca', 3, 'Central Toronto', 60, 'Standard', 102),
(2003, 2, 'Four Seasons Toronto 3', '416-222-2224', 'fs3@fourseasons.ca', 5, 'Eastside Toronto', 60, 'Budget', 102),
(2004, 2, 'Four Seasons Toronto 4', '416-222-2225', 'fs4@fourseasons.ca', 4, 'Westside Toronto', 60, 'Luxury', 102),
(2005, 2, 'Four Seasons Toronto 5', '416-222-2226', 'fs5@fourseasons.ca', 3, 'Northside Toronto', 60, 'Standard', 102),
(2006, 2, 'Four Seasons Toronto 6', '416-222-2227', 'fs6@fourseasons.ca', 5, 'Eastside Toronto', 60, 'Budget', 102),
(2007, 2, 'Four Seasons Toronto 7', '416-222-2228', 'fs7@fourseasons.ca', 4, 'Central Toronto', 60, 'Luxury', 102),
(2008, 2, 'Four Seasons Toronto 8', '416-222-2229', 'fs8@fourseasons.ca', 3, 'Westside Toronto', 60, 'Standard', 102);

-- For Delta Hotels (Chain 3, Manager 103)
INSERT INTO Hotel (Hotel_ID, Hotel_Group_ID, Name, Phone_Number, Email_Address, Stars, Address, Total_Rooms, Category, Manager_RS_Number)
VALUES 
(3001, 3, 'Delta Vancouver 1', '604-333-3333', 'delta1@deltahotels.ca', 5, 'Downtown Vancouver', 70, 'Luxury', 103),
(3002, 3, 'Delta Vancouver 2', '604-333-3334', 'delta2@deltahotels.ca', 4, 'Downtown Vancouver', 70, 'Standard', 103),
(3003, 3, 'Delta Vancouver 3', '604-333-3335', 'delta3@deltahotels.ca', 3, 'Uptown Vancouver', 70, 'Budget', 103),
(3004, 3, 'Delta Vancouver 4', '604-333-3336', 'delta4@deltahotels.ca', 5, 'Suburban Vancouver', 70, 'Luxury', 103),
(3005, 3, 'Delta Vancouver 5', '604-333-3337', 'delta5@deltahotels.ca', 4, 'Midtown Vancouver', 70, 'Standard', 103),
(3006, 3, 'Delta Vancouver 6', '604-333-3338', 'delta6@deltahotels.ca', 3, 'Uptown Vancouver', 70, 'Budget', 103),
(3007, 3, 'Delta Vancouver 7', '604-333-3339', 'delta7@deltahotels.ca', 5, 'Downtown Vancouver', 70, 'Luxury', 103),
(3008, 3, 'Delta Vancouver 8', '604-333-3340', 'delta8@deltahotels.ca', 4, 'Suburban Vancouver', 70, 'Standard', 103);

-- For Sandman Hotels (Chain 4, Manager 104)
INSERT INTO Hotel (Hotel_ID, Hotel_Group_ID, Name, Phone_Number, Email_Address, Stars, Address, Total_Rooms, Category, Manager_RS_Number)
VALUES 
(4001, 4, 'Sandman Calgary 1', '403-444-4444', 'sandman1@sandmanhotels.ca', 4, 'Central Calgary', 80, 'Luxury', 104),
(4002, 4, 'Sandman Calgary 2', '403-444-4445', 'sandman2@sandmanhotels.ca', 3, 'Central Calgary', 80, 'Standard', 104),
(4003, 4, 'Sandman Calgary 3', '403-444-4446', 'sandman3@sandmanhotels.ca', 5, 'East Calgary', 80, 'Budget', 104),
(4004, 4, 'Sandman Calgary 4', '403-444-4447', 'sandman4@sandmanhotels.ca', 4, 'West Calgary', 80, 'Luxury', 104),
(4005, 4, 'Sandman Calgary 5', '403-444-4448', 'sandman5@sandmanhotels.ca', 3, 'North Calgary', 80, 'Standard', 104),
(4006, 4, 'Sandman Calgary 6', '403-444-4449', 'sandman6@sandmanhotels.ca', 5, 'East Calgary', 80, 'Budget', 104),
(4007, 4, 'Sandman Calgary 7', '403-444-4450', 'sandman7@sandmanhotels.ca', 4, 'Central Calgary', 80, 'Luxury', 104),
(4008, 4, 'Sandman Calgary 8', '403-444-4451', 'sandman8@sandmanhotels.ca', 3, 'West Calgary', 80, 'Standard', 104);

-- For Holiday Inn (Chain 5, Manager 105)
INSERT INTO Hotel (Hotel_ID, Hotel_Group_ID, Name, Phone_Number, Email_Address, Stars, Address, Total_Rooms, Category, Manager_RS_Number)
VALUES 
(5001, 5, 'Holiday Inn Ottawa 1', '613-555-5555', 'holidayinn1@holidayinn.ca', 5, 'Downtown Ottawa', 90, 'Luxury', 105),
(5002, 5, 'Holiday Inn Ottawa 2', '613-555-5556', 'holidayinn2@holidayinn.ca', 4, 'Downtown Ottawa', 90, 'Standard', 105),
(5003, 5, 'Holiday Inn Ottawa 3', '613-555-5557', 'holidayinn3@holidayinn.ca', 3, 'Uptown Ottawa', 90, 'Budget', 105),
(5004, 5, 'Holiday Inn Ottawa 4', '613-555-5558', 'holidayinn4@holidayinn.ca', 5, 'Suburb Ottawa', 90, 'Luxury', 105),
(5005, 5, 'Holiday Inn Ottawa 5', '613-555-5559', 'holidayinn5@holidayinn.ca', 4, 'Midtown Ottawa', 90, 'Standard', 105),
(5006, 5, 'Holiday Inn Ottawa 6', '613-555-5560', 'holidayinn6@holidayinn.ca', 3, 'Uptown Ottawa', 90, 'Budget', 105),
(5007, 5, 'Holiday Inn Ottawa 7', '613-555-5561', 'holidayinn7@holidayinn.ca', 5, 'Downtown Ottawa', 90, 'Luxury', 105),
(5008, 5, 'Holiday Inn Ottawa 8', '613-555-5562', 'holidayinn8@holidayinn.ca', 4, 'Suburb Ottawa', 90, 'Standard', 105);

-- 2e. Insert Hotel Rooms for one hotel per chain (each gets 5 rooms with capacities 1 to 5)

-- Rooms for Fairmont Hotels – Hotel 1001
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES
(1, 1001, 150.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC', 'Available'),
(2, 1001, 200.00, 2, 'Mountain View', FALSE, FALSE, 'TV, AC, Fridge', 'Available'),
(3, 1001, 250.00, 3, 'Sea View', TRUE, FALSE, 'TV, Fridge', 'Available'),
(4, 1001, 300.00, 4, 'Mountain View', TRUE, FALSE, 'AC, Fridge', 'Available'),
(5, 1001, 350.00, 5, 'Sea View', FALSE, FALSE, 'TV, AC, Fridge, WiFi', 'Available');

-- Rooms for Four Seasons – Hotel 2001
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES
(1, 2001, 160.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC', 'Available'),
(2, 2001, 210.00, 2, 'Mountain View', FALSE, FALSE, 'TV, AC, Fridge', 'Available'),
(3, 2001, 260.00, 3, 'Sea View', TRUE, FALSE, 'TV, Fridge', 'Available'),
(4, 2001, 310.00, 4, 'Mountain View', TRUE, FALSE, 'AC, Fridge', 'Available'),
(5, 2001, 360.00, 5, 'Sea View', FALSE, FALSE, 'TV, AC, Fridge, WiFi', 'Available');

-- Rooms for Delta Hotels – Hotel 3001
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES
(1, 3001, 170.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC', 'Available'),
(2, 3001, 220.00, 2, 'Mountain View', FALSE, FALSE, 'TV, AC, Fridge', 'Available'),
(3, 3001, 270.00, 3, 'Sea View', TRUE, FALSE, 'TV, Fridge', 'Available'),
(4, 3001, 320.00, 4, 'Mountain View', TRUE, FALSE, 'AC, Fridge', 'Available'),
(5, 3001, 370.00, 5, 'Sea View', FALSE, FALSE, 'TV, AC, Fridge, WiFi', 'Available');

-- Rooms for Sandman Hotels – Hotel 4001
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES
(1, 4001, 180.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC', 'Available'),
(2, 4001, 230.00, 2, 'Mountain View', FALSE, FALSE, 'TV, AC, Fridge', 'Available'),
(3, 4001, 280.00, 3, 'Sea View', TRUE, FALSE, 'TV, Fridge', 'Available'),
(4, 4001, 330.00, 4, 'Mountain View', TRUE, FALSE, 'AC, Fridge', 'Available'),
(5, 4001, 380.00, 5, 'Sea View', FALSE, FALSE, 'TV, AC, Fridge, WiFi', 'Available');

-- Rooms for Holiday Inn – Hotel 5001
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES
(1, 5001, 190.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC', 'Available'),
(2, 5001, 240.00, 2, 'Mountain View', FALSE, FALSE, 'TV, AC, Fridge', 'Available'),
(3, 5001, 290.00, 3, 'Sea View', TRUE, FALSE, 'TV, Fridge', 'Available'),
(4, 5001, 340.00, 4, 'Mountain View', TRUE, FALSE, 'AC, Fridge', 'Available'),
(5, 5001, 390.00, 5, 'Sea View', FALSE, FALSE, 'TV, AC, Fridge, WiFi', 'Available');

-- 2f. Insert Reservations (To Test Query #4)
INSERT INTO Reserved (Customer_RS_Number, Room_ID, Hotel_ID, Start_Date, Finish_Date, Paid)
VALUES 
(201, 1, 1001, '2024-07-10', '2024-07-15', TRUE),
(201, 3, 3001, '2024-08-05', '2024-08-10', FALSE);

-- SECTION 3: DATABASE QUERIES (Examples)

-- Query 1: List hotels with star rating 4 or above.
SELECT Hotel_ID, Name, Stars 
FROM Hotel 
WHERE Stars >= 4;

-- Query 2: Aggregation Query – Count available rooms per area.
SELECT H.Address, COUNT(*) AS Available_Rooms
FROM Hotel H 
JOIN Hotel_Room HR ON H.Hotel_ID = HR.Hotel_ID
WHERE HR.Availability_Status = 'Available'
GROUP BY H.Address;

-- Query 3: Nested Query – List hotels that have at least one available room.
SELECT *
FROM Hotel
WHERE Hotel_ID IN (
    SELECT DISTINCT Hotel_ID 
    FROM Hotel_Room 
    WHERE Availability_Status = 'Available'
);

-- Query 4: Join Query – List reservation details with customer names and hotel names.
SELECT R.Customer_RS_Number, C.First_Name, C.Last_Name, R.Room_ID, H.Name AS Hotel_Name, R.Start_Date, R.Finish_Date
FROM Reserved R
JOIN Customer C ON R.Customer_RS_Number = C.RS_Number
JOIN Hotel H ON R.Hotel_ID = H.Hotel_ID;


-- SECTION 4: DATABASE MODIFICATIONS & TRIGGER TESTING

-- 4a. Test Trigger – Inserting a Reservation (should set room status to 'Booked')
INSERT INTO Reserved (Customer_RS_Number, Room_ID, Hotel_ID, Start_Date, Finish_Date, Paid)
VALUES (201, 1, 1001, '2025-03-01', '2025-03-05', FALSE);

-- Verify that the room status has been updated:
SELECT * FROM Hotel_Room WHERE Hotel_ID = 1001 AND Room_ID = 1;

-- 4b. Test Trigger – Inserting a Rent Record (should set room status to 'Rented')
INSERT INTO Rents (Customer_RS_Number, Employee_RS_Number, Room_ID, Hotel_ID, Start_Date, Finish_Date)
VALUES (201, 101, 2, 1001, '2025-03-01', '2025-03-05');
-- Verify that the room status has been updated:
SELECT * FROM Hotel_Room WHERE Hotel_ID = 1001 AND Room_ID = 2;

-- 4c. Test an Update Operation – Update the repairs status for a hotel room.
-- We update the Repairs_Need field.
-- For example, we flag Room 3 in Hotel 1001 as needing repair.
UPDATE Hotel_Room
SET Repairs_Need = FALSE
WHERE Hotel_ID = 1001 AND Room_ID = 3;

-- Verify the update by selecting the room's details:
SELECT Room_ID, Repairs_Need
FROM Hotel_Room
WHERE Hotel_ID = 1001;
-- 4d. Test a Delete Operation (Cascading Delete) – Delete one hotel and its rooms.
DELETE FROM Hotel 
WHERE Hotel_ID = 1008;
-- Verify deletion from Hotel and cascading deletion in Hotel_Room:
SELECT * FROM Hotel WHERE Hotel_ID = 1008;
SELECT * FROM Hotel_Room WHERE Hotel_ID = 1008;

-- 4e. Test Constraint Violation – Attempt to insert a room with capacity 0 (should fail).
INSERT INTO Hotel_Room (Room_ID, Hotel_ID, Price, Capacity, View, Expandable, Repairs_Need, Amenities, Availability_Status)
VALUES (6, 1001, 400.00, 1, 'Sea View', TRUE, FALSE, 'TV, AC, Fridge', 'Available');


-- SECTION 5: INDEXES & VIEWS TESTING

-- To check index usage:
EXPLAIN SELECT * FROM Hotel WHERE Hotel_Group_ID = 1;
EXPLAIN SELECT * FROM Hotel_Room WHERE Price BETWEEN 150 AND 250;
EXPLAIN SELECT * FROM Customer WHERE Identification_Number = '666-66-6666';

-- Test the Views:
-- View 1: Available_Rooms_Per_Area
SELECT * FROM Available_Rooms_Per_Area;
-- View 2: Room_Capacity_Aggregate
SELECT * FROM Room_Capacity_Aggregate;
