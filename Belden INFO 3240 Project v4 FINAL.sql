--INFO 3240 Database Project Part 1
--Rowan Belden

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'Inkwell')
	CREATE DATABASE Inkwell
GO

USE Inkwell

-- Alter the path so the script can find the CSV files 

DECLARE @data_path NVARCHAR(256);
SELECT @data_path = 'C:\Users\Rowan\Desktop\INFO 3240\Project\';

-- Delete existing tables

------- DROP TABLES
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Book_Genre'
       )
	DROP TABLE Book_Genre;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Book_Library'
       )
	DROP TABLE Book_Library;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Reservation'
       )
	DROP TABLE Reservation;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Loan'
       )
	DROP TABLE Loan;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Customer'
       )
	DROP TABLE Customer;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Library_Employee'
       )
	DROP TABLE Library_Employee;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Book'
       )
	DROP TABLE Book;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Employee'
       )
	DROP TABLE Employee;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Library'
       )
	DROP TABLE [Library];

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Publisher'
       )
	DROP TABLE Publisher;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Author'
       )
	DROP TABLE Author;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Genre'
       )
	DROP TABLE Genre;


-- Create Tables

CREATE TABLE Genre
	(GenreID	INT IDENTITY CONSTRAINT pk_genre_id PRIMARY KEY,
	 GenreName	NVARCHAR(50)
	);

CREATE TABLE Author
	(AuthorID	INT IDENTITY(2001,1) CONSTRAINT pk_author_id PRIMARY KEY,
	 FirstName	NVARCHAR(50),
	 LastName	NVARCHAR(50)
	);

CREATE TABLE Publisher
	(PublisherID	INT IDENTITY(3001,1) CONSTRAINT pk_publisher_id PRIMARY KEY,
	 PubName		NVARCHAR(100)
	);

CREATE TABLE [Library]
	(LibraryID		INT IDENTITY CONSTRAINT pk_library_id PRIMARY KEY,
	 LibraryName	NVARCHAR(100) CONSTRAINT nn_library_name NOT NULL,
	 [Address]		NVARCHAR(100),
	 City			NVARCHAR(50),
	 [State]		NVARCHAR(50),
	 ZipCode		INT,
	 AreaCode		INT,
	 Phone			NVARCHAR(20)
	);

CREATE TABLE Employee
	(EmployeeID	INT IDENTITY(2001,1) CONSTRAINT pk_employee_id PRIMARY KEY,
	 FirstName	NVARCHAR(50),
	 LastName	NVARCHAR(50),
	 Email		NVARCHAR(100),
	 AreaCode	INT,
	 Phone		NVARCHAR(20),
	 [Address]	NVARCHAR(20),
	 City		NVARCHAR(20),
	 [State]	NVARCHAR(20),
	 ZipCode	INT
	);

CREATE TABLE Book
	(BookID			INT IDENTITY(7001,1) CONSTRAINT pk_book_id PRIMARY KEY,
	 AuthorID		INT CONSTRAINT fk_book_author REFERENCES Author(AuthorID),
	 PublisherID	INT CONSTRAINT fk_book_publisher REFERENCES Publisher(PublisherID),
	 Title			NVARCHAR(100),
	 [Year]			INT,
	 AvailCopies	INT,
	 TotalCopies	INT
	);

CREATE TABLE Book_Genre
	(Book_GenreID	INT IDENTITY(9001,1) CONSTRAINT pk_book_genre PRIMARY KEY,
	BookID			INT CONSTRAINT fk_book_genre_book REFERENCES Book(BookID),
	GenreID			INT CONSTRAINT fk_book_genre_genre REFERENCES Genre(GenreID)
	);

CREATE TABLE Book_Library
	(Book_LibraryID	INT CONSTRAINT pk_book_library_id PRIMARY KEY,
	 BookID			INT CONSTRAINT fk_book_library_book REFERENCES Book(BookID),
	 LibraryID		INT CONSTRAINT fk_book_library_library REFERENCES Library(LibraryID)
	);

CREATE TABLE Customer
	(CustomerID	INT IDENTITY(2001,1) CONSTRAINT pk_customer_id PRIMARY KEY,
	 FirstName	NVARCHAR(50),
	 LastName	NVARCHAR(50),
	 Email		NVARCHAR(100),
	 Phone		NVARCHAR(20),
	 [Address]	NVARCHAR(100),
	 City		NVARCHAR(100),
	 [State]	NVARCHAR(20),
	 ZipCode	INT
	);

CREATE TABLE Loan
	(LoanID			INT IDENTITY(10000,1) CONSTRAINT pk_loan_id PRIMARY KEY,
	 BookID			INT CONSTRAINT fk_loan_book_id REFERENCES Book(BookID),
	 CustomerID		INT CONSTRAINT fk_loan_customer_id REFERENCES Customer(CustomerID),
	 LibraryID		INT CONSTRAINT fk_loan_library_id REFERENCES [Library](LibraryID),
	 DateOut		DATE,
	 DateDue		DATE,
	 DateReturned	DATE
	 );

CREATE TABLE Reservation
	(ReservationID	INT CONSTRAINT pk_reservation_id PRIMARY KEY,
	BookID			INT CONSTRAINT fk_reservation_book REFERENCES Book(BookID),
	CustomerID		INT CONSTRAINT fk_reservation_customer REFERENCES Customer(CustomerID),
	LibraryID		INT CONSTRAINT fk_reservation_library REFERENCES Library(LibraryID),
	ReservationDate DATE,
	PickupDate		DATE,
	ReturnDate		DATE
	);

CREATE TABLE Library_Employee
	(Library_EmployeeID		INT IDENTITY(13001,1) CONSTRAINT pk_library_employee_id PRIMARY KEY,
	 LibraryID				INT CONSTRAINT fk_library_employee_library REFERENCES Library(LibraryID),
	 EmployeeID				INT CONSTRAINT fk_library_employee_employee REFERENCES Employee(EmployeeID)
	);


--Load Table Data with Bulk Insert

--Bulk Insert the Genre Table

EXECUTE (N'BULK INSERT Genre FROM ''' + @data_path + N'GenreTablev2.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Author Table

EXECUTE (N'BULK INSERT Author FROM ''' + @data_path + N'AuthorTablev2.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

-- Bulk Insert Publisher Table Data

EXECUTE (N'BULK INSERT Publisher FROM ''' + @data_path + N'PublisherTablev5.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

-- Bulk Insert the Libary Table

EXECUTE (N'BULK INSERT Library FROM ''' + @data_path + N'LibraryTable.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Employee Table

EXECUTE (N'BULK INSERT Employee FROM ''' + @data_path + N'EmployeeTable.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Book Table

EXECUTE (N'BULK INSERT Book FROM ''' + @data_path + N'BookTablev3.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Book_Genre Table

EXECUTE (N'BULK INSERT Book_Genre FROM ''' + @data_path + N'Book_GenreTablev2.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert Book_Library Table

EXECUTE (N'BULK INSERT Book_Library FROM ''' + @data_path + N'Book_LibraryTablev3.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert Customer Table

EXECUTE (N'BULK INSERT Customer FROM ''' + @data_path + N'CustomerTable.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Loan Table

EXECUTE (N'BULK INSERT Loan FROM ''' + @data_path + N'LoanTablev4.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Reservation Table

EXECUTE (N'BULK INSERT Reservation FROM ''' + @data_path + N'ReservationTablev3.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--Bulk Insert the Library_Employee Table

EXECUTE (N'BULK INSERT Library_Employee FROM ''' + @data_path + N'Library_EmployeeTable.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

-- List table names and row counts for confirmation
--

GO
SET NOCOUNT ON
SELECT 'Genre' AS "Table",		COUNT(*) AS "Rows"	FROM Genre				UNION
SELECT 'Author',				COUNT(*)			FROM Author				UNION
SELECT 'Publisher',				COUNT(*)			FROM Publisher			UNION
SELECT 'Library',				COUNT(*)			FROM [Library]			UNION
SELECT 'Employee',				COUNT(*)			FROM Employee			UNION
SELECT 'Book',					COUNT(*)			FROM Book				UNION
SELECT 'Book_Genre',			COUNT(*)			FROM Book_Genre			UNION
SELECT 'Book_Library',			COUNT(*)			FROM Book_Library		UNION
SELECT 'Customer',				COUNT(*)			FROM Customer			UNION
SELECT 'Loan',					COUNT(*)			FROM Loan				UNION
SELECT 'Reservation',			COUNT(*)			FROM Reservation		UNION
SELECT 'Library_Employee',		COUNT(*)			FROM Library_Employee
ORDER BY 1;
SET NOCOUNT OFF
GO

--- VIEWS------------------------------------------------------------------------------------
-- Drop the view if it exists.

DROP VIEW IF EXISTS dbo.vw_BookDetails; 
GO

-- Book Detail View
-- This view combines the book title, author, publisher, and release year in one table
CREATE VIEW dbo.vw_BookDetails AS
SELECT 
	b.BookID, 
	b.Title, 
	a.FirstName + ' ' + a.LastName AS AuthorName, 
	p.PubName AS PublisherName,
	b.[Year]
FROM 
	Book b
JOIN 
	Author a 
ON 
	b.AuthorID = a.AuthorID
JOIN 
	Publisher p 
ON 
	b.PublisherID = p.PublisherID;

GO

SELECT * FROM dbo.vw_BookDetails

------- Genre Detail View

DROP VIEW IF EXISTS dbo.vw_GenreDetails; 
GO
-- This view includes book title, genre, and author. Books can have multiple genres.
CREATE VIEW dbo.vw_GenreDetails AS
SELECT 
	b.BookID, 
	b.Title, 
	g.GenreName, 
	a.FirstName, 
	a.LastName
FROM 
	Book b
JOIN
	Book_Genre bg 
ON 
	b.BookID = bg.BookID
JOIN 
	Genre g 
ON 
	bg.GenreID = g.GenreID
JOIN 
	Author a 
ON 
	b.AuthorID = a.AuthorID;

GO

SELECT * FROM dbo.vw_GenreDetails


--- User Defined Functions-------------------------------------------------------
--- Full Name Function
DROP FUNCTION IF EXISTS dbo.udf_FullName;
GO
-- This function combines the firstname and lastname fields into full names
CREATE FUNCTION dbo.udf_FullName(@FirstName VARCHAR(50), @LastName VARCHAR(50)) RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @FullName VARCHAR(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END;

GO

SELECT AuthorID, dbo.udf_FullName(FirstName, LastName) AS [Author Full Name] FROM Author;

----Book Count By Author User Defined Function
DROP FUNCTION IF EXISTS dbo.udf_BookCountByAuthor;
GO

CREATE FUNCTION dbo.udf_BookCountByAuthor (@LastName VARCHAR(50)) RETURNS INT AS
BEGIN
    DECLARE @BookCount INT
    SELECT 
		@BookCount = COUNT(*)
    FROM 
		Book b
    JOIN 
		Author a 
	ON 
		b.AuthorID = a.AuthorID
    WHERE 
		a.LastName = @LastName;

    RETURN @BookCount;
END;

GO

-- Change the @LastName Variable to the desired author
DECLARE @LastName VARCHAR(50)
SET @LastName = 'Orwell'
SELECT dbo.udf_BookCountByAuthor(@LastName) AS [Authors Book Count]

----- PROCEDURES-----------------------------------------------

-- Customer Loan Procedure
DROP PROCEDURE IF EXISTS dbo.usp_CustomerLoans;  
GO 
-- This procedure displays which customers have books loaned out and the title of the loaned book
CREATE PROCEDURE dbo.usp_CustomerLoans AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
		c.CustomerID, 
		c.FirstName, 
		c.LastName,
		b.Title,
		l.LoanID
    FROM 
		Customer c
    LEFT JOIN 
		Loan l 
	ON 
		c.CustomerID = l.CustomerID
	LEFT JOIN
		Book b
	ON
		l.BookID = b.BookID
    ORDER BY 
		c.CustomerID;
    
    RETURN 0;
END;

GO

EXEC dbo.usp_CustomerLoans;
-- Library Reservations Procedure
DROP PROCEDURE IF EXISTS dbo.usp_LibraryReservations;  
GO 
-- This procedure presents reservations with the library the book is reserved from, the title, customer name, and pickup & return dates
CREATE PROCEDURE dbo.usp_LibraryReservations AS

    SET NOCOUNT ON;

    SELECT 
		l.LibraryName, 
		r.ReservationID, 
		b.Title, 
		c.FirstName, 
		c.LastName,
		r.PickupDate,
		r.ReturnDate
    FROM 
		[Library] l
    JOIN 
		Reservation r 
	ON 
		l.LibraryID = r.LibraryID
    JOIN 
		Book b 
	ON 
		r.BookID = b.BookID
    JOIN 
		Customer c 
	ON 
		r.CustomerID = c.CustomerID
    ORDER BY 
		l.LibraryName, 
		r.ReservationID;
    
    RETURN 0;

GO

EXEC dbo.usp_LibraryReservations;
