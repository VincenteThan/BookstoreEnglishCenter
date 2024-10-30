-- Create a table named Books
CREATE TABLE IF NOT EXISTS Books (
    BookID INTEGER PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Price DECIMAL(8, 0),
    PublicationYear INTEGER
);

-- Create a table named Customers
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INTEGER PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address VARCHAR(300)
);

-- Create a table named Orders
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INTEGER PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(9, 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE /*this ON DELETE CASCADE feature help delete a record and all its related data across multiple tables in one action.*/
);

-- Create a table named Orders
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INTEGER PRIMARY KEY,
    OrderID INTEGER,
    BookID INTEGER,
    Quantity INTEGER,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
);

--Insert data into the table "Books"
INSERT INTO Books (BookID, Title, Author, Genre, Price, PublicationYear)
VALUES 
(1, 'IELTS Speaking Tests', 'Nguyen Van Nam', 'Speaking', 200000, 2020),
(2, 'IELTS Writing Task 1', 'Nguyen Thi Lan', 'Writing', 300000, 2021),
(3, 'IELTS Vocabulary for Listening', 'Nguyen Thi Tra My', 'Vocabulary', 150000, 2023);

--Insert data into the table "Customers"
INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, Address)
VALUES
(1, 'Nguyen Nhat Nam', 'nhatnam@example.com', '123-456-7890', '140 Tran Hung Dao Street'),
(2, 'Dao Thi Nhung', 'nhungdao@example.com', '987-654-6541', '4A Dien Bien Phu Street');

--Insert data into the table "Orders"
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 1, '2024-10-10', 500000),
(2, 2, '2024-10-11', 150000);

--Insert data into the table "OrderDetails"
INSERT INTO OrderDetails (OrderDetailID, OrderID, BookID, Quantity)
VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 2, 3, 1);

--PERFORM QUERIES--

-- Get all books with price greater than 200,000 VND
SELECT * FROM Books WHERE Price > 200000;

-- List all customers who have made an order
SELECT DISTINCT Customers.Name, Customers.Email 
FROM Customers /*specify the table name before the column can help avoid overlapping 
in case other tables also have the same name of column*/
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- Get the total amount spent by each customer
SELECT Customers.Name, SUM(Orders.TotalAmount) AS TotalSpent 
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.Name;

-- List all orders with book titles included
SELECT Orders.OrderID, Orders.OrderDate, Books.Title, OrderDetails.Quantity
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Books ON OrderDetails.BookID = Books.BookID;

-- Find the most popular book by quantity ordered
SELECT Books.Title, SUM(OrderDetails.Quantity) AS TotalOrdered
FROM Books
JOIN OrderDetails ON Books.BookID = OrderDetails.BookID
GROUP BY Books.Title
ORDER BY TotalOrdered DESC /*DESC (descending) helps sort values from highest to lowest*/
LIMIT 1; /*Limits the result to just the book with the highest total ordered quantity*/

-- Calculate the average book price by genre
SELECT Genre, AVG(Price) AS AvgPrice
FROM Books
GROUP BY Genre;

-- Find the customers who ordered books in a specific genre (ex: 'Classic')
SELECT DISTINCT Customers.Name, Customers.Email
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Books ON OrderDetails.BookID = Books.BookID
WHERE Books.Genre = 'Classic';