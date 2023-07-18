-------------------------------------------------------------------------------
-- The following lines make sure you can rerun this whole script as often
-- as you want.
DROP TABLE IF EXISTS BookingLodge;
DROP TABLE IF EXISTS Lodge;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Activity;
DROP TABLE IF EXISTS ActivityLeader;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Park;
DROP TABLE IF EXISTS Customer;


-------------------------------------------------------------------------------
-- Task 1: Create Tables and Insert Data
-------------------------------------------------------------------------------

CREATE TABLE Customer (
  CustomerNo INT PRIMARY KEY NOT NULL,
    Firstname VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    PhoneNo TEXT NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL
);

CREATE TABLE Park (
  ParkID INT PRIMARY KEY NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Postcode VARCHAR(8) NOT NULL
);

CREATE TABLE Booking (
  BookingNo INT PRIMARY KEY NOT NULL,
  BookingDate DATE NOT NULL,
  ArrivalDate DATE NOT NULL CHECK (ArrivalDate >= CURRENT_DATE),
  DepartureDate DATE NOT NULL CHECK (DepartureDate >=ArrivalDate),
  SpecialRequests TEXT,
  CustomerNo INT NOT NULL,
  ParkID INT NOT NULL,
  FOREIGN KEY (CustomerNo) REFERENCES Customer(CustomerNo),
  FOREIGN KEY (ParkID) REFERENCES Park(ParkID)
);

CREATE TABLE ActivityLeader (
  StaffID INT PRIMARY KEY NOT NULL,
  Firstname VARCHAR(50) NOT NULL,
  Surname VARCHAR(50) NOT NULL,
  DOB DATE NOT NULL CHECK (DOB < CURRENT_DATE),
  Address VARCHAR(100) NOT NULL,
  PhoneNo VARCHAR(20) NOT NULL,
  Salary MONEY NOT NULL CHECK (Salary >= CAST(0 AS MONEY)),
  WorkAdjustments TEXT,
  DBSCheck VARCHAR(50),
  Speciality VARCHAR(50) NOT NULL,
  ParkID INT NOT NULL,
  FOREIGN KEY (ParkID) REFERENCES Park(ParkID)
);

CREATE TABLE Activity (
    ActivityID INT PRIMARY KEY NOT NULL,
  Name VARCHAR(50) NOT NULL,
  OnDateTime TIMESTAMP NOT NULL,
  Duration INT NOT NULL,
  TargetAudience VARCHAR(50) NOT NULL CHECK (TargetAudience IN ('Children', 'Adults', 'All')),
  ParkID INT NOT NULL,
  StaffID INT NOT NULL,
  FOREIGN KEY (ParkID) REFERENCES Park(ParkID),
  FOREIGN KEY (StaffID) REFERENCES ActivityLeader(StaffID)
);

CREATE TABLE Admin (
  StaffID INT PRIMARY KEY NOT NULL,
  Firstname VARCHAR(50) NOT NULL,
  Surname VARCHAR(50) NOT NULL,
  DOB DATE NOT NULL CHECK (DOB < CURRENT_DATE),
  Address VARCHAR(100) NOT NULL,
  PhoneNo TEXT NOT NULL,
  Salary MONEY NOT NULL CHECK (Salary >= CAST(0 AS MONEY)),
  WorkAdjustments TEXT,
  Role VARCHAR(50) NOT NULL CHECK (Role IN ('Manager', 'Receptionist', 'HR', 'Sales', 'Marketing')),
  ParkID INT NOT NULL,
  FOREIGN KEY (ParkID) REFERENCES Park(ParkID)
);

CREATE TABLE Lodge (
  LodgeID INT PRIMARY KEY NOT NULL,
  Area VARCHAR(50) NOT NULL CHECK (Area IN ('Central', 'Outer', 'Exclusive')),
  LodgeNo INT NOT NULL CHECK (LodgeNo > 0),
  MaxOccupants INT NOT NULL CHECK (MaxOccupants > 0),
  WheelchairAccessible BOOLEAN NOT NULL,
  DogsAllowed BOOLEAN NOT NULL,
  ParkID INT NOT NULL,
  UNIQUE (LodgeNo, ParkID),
  FOREIGN KEY (ParkID) REFERENCES Park(ParkID)
);

CREATE TABLE BookingLodge (
  BookingNo INT NOT NULL,
  LodgeID INT NOT NULL,
  NumberGuests INT NOT NULL,
  Price MONEY NOT NULL,
  PRIMARY KEY (BookingNo, LodgeID),
  FOREIGN KEY (BookingNo) REFERENCES Booking(BookingNo),
  FOREIGN KEY (LodgeID) REFERENCES Lodge(LodgeID)
);

-- Add data to the tables:
-- (add your queries here)

INSERT INTO Customer (CustomerNo, Firstname, Surname, PhoneNo, EmailAddress)
VALUES  (1, 'John', 'Smith', '0123456789', 'email@address.com'),
    	(2, 'Anna', 'Jones', '0123456780', 'anna@example.com'),
    	(3, 'Peter', 'Brown', '0123456781', 'pb@example.com');

INSERT INTO Park (ParkID, Address, Postcode)
VALUES (1, '123 Example Street', 'EX1 111'),
       (2, '456 Example Street', 'EX1 222'),
       (3, '789 Example Street', 'EX1 333');
INSERT INTO Booking (BookingNo, BookingDate, ArrivalDate, DepartureDate, SpecialRequests, CustomerNo, ParkID)
VALUES (1, '2023-05-01', '2023-06-01', '2023-06-05', null, 1, 1),
       (2, '2023-05-01', '2023-06-01', '2023-06-05', null, 2, 2),
       (3, '2023-05-01', '2023-06-01', '2023-06-05', null, 3, 3);
INSERT INTO ActivityLeader (StaffID, Firstname, Surname, DOB, Address, PhoneNo, Salary, WorkAdjustments, DBSCheck, Speciality, ParkID)
VALUES (1, 'Freya', 'Evans', '1980-01-01', '1 Example Street', '0000000001', '£31,000.00', NULL, NULL, 'Climbing', 1),
       (2, 'George', 'Bishop', '1989-02-13', '2 Example Street', '0000000002', '£31,000.00', NULL, NULL, 'Surfing', 1),
       (3, 'Amelia', 'Thomas', '1999-12-07', '3 Example Street', '0000000003', '£31,000.00', NULL, NULL, 'Climbing', 2),
       (4, 'Olivia', 'Williams', '1999-12-07', '4 Example Street', '0000000004', '£31,000.00', NULL, NULL, 'Climbing', 1);
INSERT INTO Activity (ActivityID, Name, OnDateTime, Duration, TargetAudience, ParkID, StaffID)
VALUES (1, 'Climbing', '2023-06-01 10:00:00', 60, 'Children', 1, 1),
       (2, 'Surfing', '2023-06-01 10:00:00', 60, 'All', 1, 2),
       (3, 'Climbing', '2023-06-01 10:00:00', 60, 'Children', 2, 3),
       (4, 'Surfing', '2023-06-01 11:00:00', 60, 'Children', 1, 2);
INSERT INTO Admin (StaffID, Firstname, Surname, DOB, Address, PhoneNo, Salary, WorkAdjustments, Role, ParkID)
VALUES (1, 'Sophie', 'Frank', '1980-01-01', '1 Example Street', '0323456780', '£31,000.00', null, 'Manager', 1),
       (2, 'Isabella', 'Smith', '1989-02-13', '2 Example Street', '0323456789', '£31,000.00', null, 'Receptionist', 1),
       (3, 'Muhammad', 'Fisher', '1999-12-07', '3 Example Street', '0323456781', '£31,000.00', null, 'HR', 2),
       (4, 'Eliot', 'Gibson', '1999-12-07', '4 Example Street', '0323456783', '£31,000.00', null, 'Sales', 3),
       (5, 'Fabio', 'Lloyd', '1999-12-07', '5 Example Street', '0323456784', '£31,000.00', null, 'Marketing', 3);
INSERT INTO Lodge (LodgeID, Area, LodgeNo, MaxOccupants, WheelchairAccessible, DogsAllowed, ParkID)
VALUES (1, 'Central', 1, 2, true, false, 1),
       (2, 'Outer', 2, 2, true, false, 1),
       (3, 'Exclusive', 3, 4, true, false, 1),
       (4, 'Central', 1, 6, true, false, 2),
       (5, 'Outer', 2, 6, true, false, 2),
       (6, 'Exclusive', 3, 4, true, false, 2);

INSERT INTO BookingLodge (BookingNo, LodgeID, NumberGuests, Price) 
VALUES (1, 1, 2, '£100.00'),
       (2, 2, 2, '£100.00'),
       (3, 3, 4, '£200.00'),
       (1, 4, 6, '£300.00'),
       (1, 5, 6, '£300.00'),
       (3, 6, 4, '£200.00');
-------------------------------------------------------------------------------
-- Task 2: Query the Database
-------------------------------------------------------------------------------

-- 2.1 List all bookings where the total price is lower than £200. Show the total price, the customer first name, surname, and the email address.

SELECT SUM(bl.Price) AS "total price",
       c.Firstname AS "first name",
       c.Surname AS "surname",
       c.EmailAddress AS "email address"
FROM 
  Booking b
  JOIN BookingLodge bl ON bl.BookingNo = b.BookingNo
  JOIN Customer c ON b.CustomerNo = c.CustomerNo 
GROUP BY 
  c.CustomerNo, c.Firstname, c.Surname, c.EmailAddress
HAVING SUM(bl.Price) < CAST(200.00 AS MONEY);

-- 2.2 Who is the most busy activity leader? Show the first name, surname,
--     and give number of activities as activityCount.

SELECT al.Firstname AS "first name",
       al.Surname AS "surname", 
       COUNT(*) AS ActivityCount
FROM Activity a
JOIN ActivityLeader al ON a.StaffID = al.StaffID
GROUP BY a.StaffID, al.Firstname, al.Surname
ORDER BY ActivityCount DESC
LIMIT 1;

-- 2.3 Take the query from 2.2 and modify it to show the three least busy activity leaders.

SELECT al.Firstname AS "first name",
       al.Surname AS "surname", 
       COUNT(a.ActivityID) AS ActivityCount
FROM ActivityLeader al
LEFT JOIN Activity a ON a.StaffID = al.StaffID
GROUP BY al.StaffID, al.FirstName, al.Surname
ORDER BY ActivityCount ASC
LIMIT 3;

-- 2.4 The following query was written to answer how much salary Sophie Frank earns.
--     However, it makes one crucial assumption, which may not be correct
--     in general when we ask for the salary of an employee. Fix the query.
--SELECT salary FROM Admin a
--WHERE a.FirstName = 'Sophie' AND a.Surname = 'Frank';
SELECT Salary
FROM Admin a
WHERE a.Firstname = 'Sophie' AND a.Surname = 'Frank'
UNION ALL
SELECT Salary
FROM ActivityLeader al
WHERE al.Firstname = 'Sophie' AND al.Surname = 'Frank';

-- 2.5 Update the data in the database to demonstrate the problem with the above query.
--     Thus, you may want to change, remove, and/or insert data into the database.

INSERT INTO ActivityLeader (StaffID, Firstname, Surname, DOB, Address, PhoneNo, Salary, WorkAdjustments, DBSCheck, Speciality, ParkID)
VALUES (5, 'Sophie', 'Frank', '1999-01-01', '5 Example Street', '0000000005', 31000, null, null, 'Surfing', 2);


-- 2.6 List the address, postcode, and the maximum number of guests (as maxGuests) that can stay in each park at a given point in time.

SELECT p.Address AS address, 
p.Postcode AS postcode,
COALESCE(SUM(l.MaxOccupants), 0) AS maxGuests
FROM Park p
LEFT JOIN Lodge l ON p.ParkID = l.ParkID
GROUP BY p.ParkID, p.Address, p.Postcode;

-- 2.7 What are the salary costs for each park?  Show the park id and the total salary costs as salary.

SELECT ParkID, 
SUM(Salary) AS Salary
FROM (
    SELECT ParkID, Salary
    FROM ActivityLeader
    UNION ALL
    SELECT ParkID, Salary
    FROM Admin
) AS employees
GROUP BY ParkID

-------------------------------------------------------------------------------
