-- Lab 6
-- mwingerd
-- Nov 17, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
SELECT
    FirstName, LastName
FROM
    customers
WHERE 
    FirstName NOT IN (SELECT FirstName
                      FROM customers
                      JOIN receipts ON Customer = CId
                      WHERE MONTH(SaleDate) = '10' 
                            AND DAY(SaleDate) >= '05' 
                            AND DAY(SaleDate) <= '11'
                            AND YEAR(SaleDate) = 2007)
ORDER BY
    FirstName, LastName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
SELECT
    t2.FirstName AS FirstName, t2.LastName As LastName, t2.MoneySpent AS MoneySpent
FROM (SELECT 
            MAX(MoneySpent) AS MoneySpent
        FROM 
            (SELECT
                FirstName, LastName, ROUND(SUM(Price), 2) AS MoneySpent
            FROM
                customers
            JOIN
                receipts ON Customer = CId
            JOIN
                items ON RNumber = Receipt
            JOIN
                goods ON Item = GId
            WHERE
                MONTH(SaleDate) = '10'
            GROUP BY
                FirstName, LastName) AS t1) AS t1
CROSS JOIN (SELECT
                FirstName, LastName, ROUND(SUM(Price), 2) AS MoneySpent
            FROM
                customers
            JOIN
                receipts ON Customer = CId
            JOIN
                items ON RNumber = Receipt
            JOIN
                goods ON Item = GId
            WHERE
                MONTH(SaleDate) = '10'
            GROUP BY
                FirstName, LastName) AS t2
WHERE
    t1.MoneySpent = t2.MoneySpent
ORDER BY
    LastName;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

SELECT 
    Distinct FirstName, LastName
FROM
    customers
WHERE
    FirstName NOT IN (
    SELECT
        Distinct FirstName
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON Receipt = RNumber
    JOIN
        goods ON item = GId
    WHERE
        MONTH(SaleDate) = '10' AND YEAR(SaleDate) = '2007' AND Food = 'Twist')
ORDER BY
    LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
SELECT
    Flavor, Food
FROM
    (SELECT 
        MAX(MaxPrice) AS MaxPrice
    FROM
        (SELECT
            Flavor, Food, SUM(Price) AS MaxPrice
        FROM
            goods
        JOIN
            items ON item = GId
        GROUP BY
            Flavor, Food) AS t1) AS t1
CROSS JOIN
    (SELECT
        Flavor, Food, SUM(Price) AS MaxPrice
    FROM
        goods
    JOIN
        items ON item = GId
    GROUP BY
        Flavor, Food) AS t2
WHERE
    t1.MaxPrice = t2.MaxPrice;


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
SELECT
    Flavor, Food, t2.TotalQty AS TotalQty
FROM 
    (SELECT
        MAX(TotalQty) AS TotalQty
    FROM
        (SELECT
            Flavor, Food, COUNT(*) AS TotalQty
        FROM
            items
        JOIN
            goods ON GId = item
        GROUP BY
            Flavor, Food) AS t1) AS t1
CROSS JOIN
    (SELECT
        Flavor, Food, COUNT(*) AS TotalQty
    FROM
        items
    JOIN
        goods ON GId = item
    GROUP BY
        Flavor, Food) AS t2
WHERE
    t1.TotalQty = t2.TotalQty;


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
SELECT
    SaleDate
FROM
    (SELECT
        MAX(Price) AS Price
    FROM
        (SELECT
            SaleDate, SUM(Price) AS Price
        FROM
            goods
        JOIN
            items ON GId = item
        JOIN
            receipts ON receipt = RNumber
        GROUP BY
            SaleDate) AS t1) AS t1
CROSS JOIN
    (SELECT
        SaleDate, SUM(Price) AS Price
    FROM
        goods
    JOIN
        items ON GId = item
    JOIN
        receipts ON receipt = RNumber
    GROUP BY
        SaleDate) AS t2
WHERE
    t1.Price = t2.Price
ORDER BY
    SaleDate;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
SELECT
    Flavor, Food, t1.Num AS QtySold
FROM
    (SELECT
    MAX(Num) AS Num
FROM
    (SELECT
    Flavor, Food, COUNT(*) AS Num
FROM
    goods
JOIN
    items ON GId = Item
JOIN
    receipts ON RNumber = Receipt
WHERE
    SaleDate = (SELECT
                    SaleDate
                FROM
                    (SELECT
                        MAX(Total) AS Total
                    FROM
                        (SELECT
                            SaleDate, ROUND(SUM(Price), 2) AS Total
                        FROM
                            goods
                        JOIN
                            items ON GId = Item
                        JOIN
                            receipts ON RNumber = Receipt
                        WHERE
                            YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
                        GROUP BY
                            SaleDate) AS t1) AS t1
                JOIN
                    (SELECT
                        SaleDate, ROUND(SUM(Price), 2) AS Total
                    FROM
                        goods
                    JOIN
                        items ON GId = Item
                    JOIN
                        receipts ON RNumber = Receipt
                    WHERE
                        YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
                    GROUP BY
                        SaleDate) AS t2 ON t1.Total = t2.Total)
GROUP BY
    Flavor, Food) AS t1) AS t1
JOIN
    (SELECT
    Flavor, Food, COUNT(*) AS Num
FROM
    goods
JOIN
    items ON GId = Item
JOIN
    receipts ON RNumber = Receipt
WHERE
    SaleDate = (SELECT
                    SaleDate
                FROM
                    (SELECT
                        MAX(Total) AS Total
                    FROM
                        (SELECT
                            SaleDate, ROUND(SUM(Price), 2) AS Total
                        FROM
                            goods
                        JOIN
                            items ON GId = Item
                        JOIN
                            receipts ON RNumber = Receipt
                        WHERE
                            YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
                        GROUP BY
                            SaleDate) AS t1) AS t1
                JOIN
                    (SELECT
                        SaleDate, ROUND(SUM(Price), 2) AS Total
                    FROM
                        goods
                    JOIN
                        items ON GId = Item
                    JOIN
                        receipts ON RNumber = Receipt
                    WHERE
                        YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
                    GROUP BY
                        SaleDate) AS t2 ON t1.Total = t2.Total)
GROUP BY
    Flavor, Food) AS t2 WHERE t1.Num = t2.Num
ORDER BY
    Flavor, Food;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Lemon' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Lemon' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Casino' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Casino' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Chocolate' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Chocolate' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Napoleon' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Napoleon' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Opera' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Opera' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Strawberry' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Strawberry' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
UNION
SELECT
    t2.Flavor AS Flavor, t2.Food AS Food, t2.FirstName AS FirstName, t2.LastName AS LastName, t2.Count AS Count
FROM
    (SELECT
        MAX(Count) AS Count
    FROM    
        (SELECT
            FirstName, LastName, COUNT(*) AS Count
        FROM
            customers
        JOIN
            receipts ON Customer = CId
        JOIN
            items ON RNumber = receipt
        JOIN
            goods ON GId = Item
        WHERE
            Food = 'Cake' AND Flavor = 'Truffle' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
        GROUP BY
            FirstName, LastName) AS t1) AS t1
CROSS JOIN
    (SELECT
        FirstName, LastName, Flavor, Food, COUNT(*) AS Count
    FROM
        customers
    JOIN
        receipts ON Customer = CId
    JOIN
        items ON RNumber = receipt
    JOIN
        goods ON GId = Item
    WHERE
        Food = 'Cake' AND Flavor = 'Truffle' AND YEAR(SaleDate) = '2007' AND MONTH(SaleDate) = '10'
    GROUP BY
        FirstName, LastName) AS t2
WHERE
    t1.Count = t2.Count
ORDER BY
    Count DESC, LastName, Flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

SELECT
    LastName, FirstName, MIN(SaleDate) AS SaleDate
FROM
    customers
JOIN
    receipts ON Customer = CId
WHERE
    MONTH(SaleDate) = 10
    AND
    (LastName, FirstName) IN (
                                SELECT
                                    t1.LastName, t1.FirstName
                                FROM
                                    (SELECT
                                        LastName, FirstName, MAX(SaleDate) AS SaleDate
                                    FROM
                                        customers
                                    JOIN
                                        receipts ON Customer = CId
                                    WHERE
                                        MONTH(SaleDate) = 10
                                    GROUP BY
                                        FirstName, LastName) AS t1
                                JOIN
                                    (SELECT
                                        LastName, FirstName, RNumber, MAX(SaleDate) AS SaleDate
                                    FROM
                                        customers
                                    JOIN
                                        receipts ON Customer = CId
                                    WHERE
                                        MONTH(SaleDate) = 10
                                    GROUP BY
                                        LastName, FirstName, RNumber) AS t2 ON t1.SaleDate = t2.SaleDate AND t1.FirstName = t2.FirstName
                                GROUP BY
                                    LastName, FirstName
                                HAVING
                                    COUNT(*) > 1)
GROUP BY
    LastName, FirstName
ORDER BY
    SaleDate, LastName;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

SELECT
    IF(t1.Price > t2.Price, 'Chocolate', 'Croissant') AS Amount
FROM
    (SELECT
        Flavor, ROUND(SUM(Price), 2) AS Price
    FROM
        goods
    JOIN
        items ON item = GId
    JOIN
        receipts ON RNumber = Receipt
    WHERE
        YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
        AND
        Flavor = 'Chocolate'
    GROUP BY
        Flavor) AS t1
JOIN
    (SELECT
        Food, ROUND(SUM(Price), 2) AS Price
    FROM
        goods
    JOIN
        items ON item = GId
    JOIN
        receipts ON RNumber = Receipt
    WHERE
        YEAR(SaleDate) = 2007 AND MONTH(SaleDate) = 10
        AND
        Food = 'Croissant'
    GROUP BY
        Food) AS t2;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

SELECT
    RoomName, RoomCode, t2.Reservation AS Reservations
FROM
    (SELECT 
        MAX(Reservation) AS Reservation
    FROM
        (SELECT
            RoomName, RoomCode, COUNT(*) AS Reservation
        FROM
            rooms
        JOIN
            reservations ON Room = RoomCode
        GROUP BY
            RoomName, RoomCode
        ORDER BY
            COUNT(*) DESC) AS t1) AS t1
CROSS JOIN
    (SELECT
        RoomName, RoomCode, COUNT(*) AS Reservation
    FROM
        rooms
    JOIN
        reservations ON Room = RoomCode
    GROUP BY
        RoomName, RoomCode
    ORDER BY
        COUNT(*) DESC) AS t2
WHERE
    t1.Reservation = t2.Reservation;


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
SELECT
    RoomName, RoomCode, t2.Days AS Days
FROM
    (SELECT
        MAX(Days) AS Days
    FROM
        (SELECT
            RoomName, SUM(DATEDIFF(CheckOut, CheckIn)) AS Days
        FROM
            reservations
        JOIN
            rooms ON RoomCode = Room
        GROUP BY
            RoomName) AS t1) AS t1
CROSS JOIN
    (SELECT
        RoomName, RoomCode, SUM(DATEDIFF(CheckOut, CheckIn)) AS Days
    FROM
        reservations
    JOIN
        rooms ON RoomCode = Room
    GROUP BY
        RoomName, RoomCode) AS t2
WHERE
    t1.Days = t2.Days
ORDER BY
    RoomName;


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
SELECT
    RoomName, t1.CheckIn, t2.CheckOut, LastName, Rate, Paid
FROM
    (SELECT
        CheckIn, CheckOut, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
    FROM
        rooms
    JOIN
        reservations ON Room = RoomCode
    GROUP BY
        CheckIn, CheckOut) AS t1
JOIN
    (SELECT 
        RoomName, CheckIn, CheckOut, Rate
    FROM 
        rooms 
    JOIN 
        reservations ON RoomCode = Room 
    GROUP BY 
        RoomName, CheckIn, CheckOut, Rate) AS t2 ON (t1.CheckIn = t2.CheckIn AND t1.CheckOut = t2.CheckOut)
JOIN
    (SELECT
        LastName, CheckIn, CheckOut
    FROM
        reservations
    JOIN
        rooms ON RoomCode = Room
    GROUP BY
        LastName, CheckIn, CheckOut) AS t3 ON (t1.CheckIn = t3.CheckIn AND t1.CheckOut = t3.CheckOut)
WHERE
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Stay all year'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Frugal not apropos'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Abscond or bolster'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Convoke and sanguine'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Interim but salutary'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Immutable before decorum'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Recluse and defiance'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Riddle to exculpate'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Harbinger but bequest'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Mendicant with cryptic'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
    OR
    (Paid, RoomName) IN (SELECT
                            MAX(Paid) AS Paid, RoomName
                        FROM
                            (SELECT
                                CheckIn, CheckOut, RoomName, SUM(DATEDIFF(CheckOut, CheckIn) * Rate) AS Paid
                            FROM
                                rooms
                            JOIN
                                reservations ON Room = RoomCode
                            WHERE
                                RoomName = 'Thrift and accolade'
                            GROUP BY
                                CheckIn, CheckOut) AS t1
                        GROUP BY
                            RoomName)
ORDER BY
    Paid DESC;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
SELECT
    RoomName, RoomCode, IF(Jul4Status >= 1, "Occupied", "Empty") AS Jul4Status
FROM
    (SELECT
        RoomName, RoomCode, SUM(IF('2010-07-04' BETWEEN CheckIn AND CheckOut, 1, 0)) AS Jul4Status
    FROM
        rooms
    JOIN
        reservations ON Room = RoomCode
    WHERE
        CheckOut != '2010-07-04'
    GROUP BY
        RoomName, RoomCode) AS t1
ORDER BY
    RoomCode;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
SELECT
    Month, NReservations, t1.MonthlyRevenue
FROM
    (SELECT
        MAX(MonthlyRevenue) AS MonthlyRevenue
    FROM
        (SELECT
            MONTHNAME(CheckIn) AS Month, COUNT(*) AS NReservations, ROUND(SUM(DATEDIFF(CheckOut, CheckIn) * Rate), 2) AS MonthlyRevenue
        FROM
            reservations
        JOIN
            rooms ON Room = RoomCode
        GROUP BY
            Month) AS t1) AS t1
CROSS JOIN
    (SELECT
        MONTHNAME(CheckIn) AS Month, COUNT(*) AS NReservations, ROUND(SUM(DATEDIFF(CheckOut, CheckIn) * Rate), 2) AS MonthlyRevenue
    FROM
        reservations
    JOIN
        rooms ON Room = RoomCode
    GROUP BY
        Month) AS t2
WHERE
    t1.MonthlyRevenue = t2.MonthlyRevenue;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

SELECT
    Last, First, t1.nstudents
FROM
    (SELECT
        MAX(nstudents) AS nstudents
    FROM
        (SELECT
            Last, First, COUNT(*) AS nstudents
        FROM
            list
        JOIN
            teachers ON teachers.Classroom = list.Classroom
        GROUP BY
            First, Last) AS t1) AS t1
CROSS JOIN
    (SELECT
        Last, First, COUNT(*) AS nstudents
    FROM
        list
    JOIN
        teachers ON teachers.Classroom = list.Classroom
    GROUP BY
        First, Last) AS t2 ON t1.nstudents = t2.nstudents;


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
SELECT
    Grade, t2.ABCCount
FROM
    (SELECT
    MAX(ABCCount) AS ABCCount
FROM
    (SELECT
        Grade, COUNT(*) AS ABCCount
    FROM
        list
    WHERE
            LastName Like 'A%'
        OR
            LastName Like 'B%'
        OR
            LastName Like 'C%'
    GROUP BY
        Grade) AS t1) AS t1
CROSS JOIN
    (SELECT
        Grade, COUNT(*) AS ABCCount
    FROM
        list
    WHERE
            LastName Like 'A%'
        OR
            LastName Like 'B%'
        OR
            LastName Like 'C%'
    GROUP BY
        Grade) AS t2 ON t1.ABCCount = t2.ABCCount
ORDER BY
    Grade;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
SELECT
    *
FROM
    (SELECT
        classroom, COUNT(*) AS Num
    FROM
        list
    GROUP BY
        classroom) AS t1
WHERE
    NUM < 
        (SELECT
            AVG(Num)
        FROM
            (SELECT
                classroom, COUNT(*) AS Num
            FROM
                list
            GROUP BY
                classroom) AS t1)
ORDER BY
    classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
SELECT
    Distinct t1.Classroom, t2.Classroom, t2.StudentCount
FROM
    (SELECT
        classroom, COUNT(*) AS StudentCount
    FROM
        list
    GROUP BY
        classroom) AS t1
JOIN
    (SELECT
        classroom, COUNT(*) AS StudentCount
    FROM
        list
    GROUP BY
        classroom) AS t2 ON (t1.classroom != t2.classroom 
                            AND t1.StudentCount = t2.StudentCount
                            AND t1.classroom < t2.classroom)
ORDER BY
    StudentCount;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
SELECT
    t1.Grade, Last
FROM
    (SELECT
        Grade, MAX(NStud) AS MStud
    FROM
        (SELECT
            t1.Grade, COUNT(Classroom) AS Num, Last, NStud
        FROM
            (SELECT
                Grade, Classroom
            FROM
                list
            GROUP BY
                Grade, Classroom) AS t1
        JOIN
            (SELECT
                Last, Grade, COUNT(*) AS NStud
            FROM
                list
            JOIN
                teachers ON list.Classroom = teachers.Classroom
            GROUP BY
                Last, Grade) AS t2
        WHERE
            t1.Grade = t2.Grade
        GROUP BY
            Grade, Last, NStud
        HAVING
            Num > 1) AS t1
    GROUP BY
        Grade) AS t1
JOIN
    (SELECT
        Last, Grade, COUNT(*) AS NStud
    FROM
        list
    JOIN
        teachers ON list.Classroom = teachers.Classroom
    GROUP BY
        Last, Grade) AS t2 ON (MStud = NStud AND t1.Grade = t2.Grade)
ORDER BY
    Grade;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

SELECT
    Campus, t1.NEnrolled
FROM
    (SELECT
        MAX(NEnrolled) AS NEnrolled
    FROM
        (SELECT
            Campus, SUM(Enrolled) AS NEnrolled
        FROM
            enrollments
        JOIN
            campuses ON Id = CampusId
        WHERE
            enrollments.Year = 2000
        GROUP BY
            Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
            Campus, SUM(Enrolled) AS NEnrolled
        FROM
            enrollments
        JOIN
            campuses ON Id = CampusId
        WHERE
            enrollments.Year = 2000
        GROUP BY
            Campus) AS t2 ON t1.NEnrolled = t2.NEnrolled
ORDER BY
    Campus;


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

SELECT
    Campus
FROM
    (SELECT
        MAX(Num)  AS Num
    FROM
        (SELECT
            Campus, degrees.Year, SUM(degrees) AS Num
        FROM
            campuses
        JOIN
            degrees ON CampusId = Id
        GROUP BY
            Campus, degrees.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, degrees.Year, SUM(degrees) AS Num
    FROM
        campuses
    JOIN
        degrees ON CampusId = Id
    GROUP BY
        Campus, degrees.Year) AS t2 ON t1.Num = t2.Num;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
SELECT
    t2.Campus, t2.Average
FROM
    (SELECT
        MIN(Average) AS Average
    FROM
        (SELECT
            Campus, ROUND(SUM(enrollments.FTE) / SUM(faculty.FTE), 1) AS Average
        FROM
            faculty
        JOIN
            enrollments ON (faculty.CampusId = enrollments.CampusId AND faculty.Year = enrollments.Year)
        JOIN
            campuses ON (campuses.Id = enrollments.CampusId AND campuses.Id = faculty.CampusId)
        WHERE
            faculty.Year = 2003 AND enrollments.Year = 2003
        GROUP BY
            Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, ROUND(SUM(enrollments.FTE) / SUM(faculty.FTE), 1) AS Average
    FROM
        faculty
    JOIN
        enrollments ON (faculty.CampusId = enrollments.CampusId AND faculty.Year = enrollments.Year)
    JOIN
            campuses ON (campuses.Id = enrollments.CampusId AND campuses.Id = faculty.CampusId)
    WHERE
        faculty.Year = 2003 AND enrollments.Year = 2003
    GROUP BY
        Campus) AS t2 ON t1.Average = t2.Average;


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
SELECT
    Campus, t2.PercentCS
FROM
    (SELECT
        MAX(PercentCS) AS PercentCS
    FROM
        (SELECT
            Campus, ROUND(SUM((Ug / Enrolled) * 100), 2) AS PercentCS
        FROM
            disciplines
        JOIN
            discEnr ON disciplines.Id = Discipline
        JOIN
            campuses ON campuses.Id = discEnr.CampusId
        JOIN
            enrollments ON enrollments.CampusId = campuses.Id AND enrollments.Year = discEnr.Year
        WHERE
            Name = 'Computer and Info. Sciences' AND discEnr.Year = 2004
        GROUP BY
            Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, ROUND(SUM((Ug / Enrolled) * 100), 2) AS PercentCS
    FROM
        disciplines
    JOIN
        discEnr ON disciplines.Id = Discipline
    JOIN
        campuses ON campuses.Id = discEnr.CampusId
    JOIN
        enrollments ON enrollments.CampusId = campuses.Id AND enrollments.Year = discEnr.Year
    WHERE
        Name = 'Computer and Info. Sciences' AND discEnr.Year = 2004
    GROUP BY
        Campus) AS t2 ON t1.PercentCS = t2.PercentCS
ORDER BY
    Campus;


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 1997
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 1997
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 1998
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 1998
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 1999
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 1999
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 2000
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 2000
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 2001
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 2001
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 2002
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 2002
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
UNION
SELECT
    Year, Campus, t2.DPE
FROM
    (SELECT
        MAX(DPE) AS DPE
    FROM
        (SELECT
            enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
        WHERE
            enrollments.Year = 2003
        GROUP BY
            enrollments.Year, Campus) AS t1) AS t1
CROSS JOIN
    (SELECT
        enrollments.Year, Campus, SUM(Degrees / Enrolled) AS DPE
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        degrees ON degrees.CampusId = Id AND degrees.Year = enrollments.Year
    WHERE
        enrollments.Year = 2003
    GROUP BY
        enrollments.Year, Campus) AS t2 ON t1.DPE = t2.DPE
ORDER BY
    Year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California Maritime Academy'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California Maritime Academy'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California Polytechnic State University-San Luis Obispo'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California Polytechnic State University-San Luis Obispo'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State Polytechnic University-Pomona'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State Polytechnic University-Pomona'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Bakersfield'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Bakersfield'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Channel Islands'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Channel Islands'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Chico'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Chico'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Dominguez Hills'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Dominguez Hills'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-East Bay'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-East Bay'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Fullerton'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Fullerton'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Los Angeles'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Los Angeles'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Monterey Bay'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Monterey Bay'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Northridge'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Northridge'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Sacramento'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Sacramento'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-San Bernardino'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-San Bernardino'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-San Marcos'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-San Marcos'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'California State University-Stanislaus'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'California State University-Stanislaus'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'Fresno State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'Fresno State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'Humboldt State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'Humboldt State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'Long Beach State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'Long Beach State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'San Diego State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'San Diego State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'San Francisco State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'San Francisco State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'San Jose State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'San Jose State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
UNION
SELECT
    Campus, Year, t2.Ratio
FROM
    (SELECT
        MAX(Ratio) AS Ratio
    FROM
        (SELECT
            Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
        FROM
            campuses
        JOIN
            enrollments ON enrollments.CampusId = Id
        JOIN
            faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
        WHERE
            Campus = 'Sonoma State University'
        GROUP BY
            Campus, enrollments.Year) AS t1) AS t1
CROSS JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        Campus = 'Sonoma State University'
    GROUP BY
        Campus, enrollments.Year) AS t2 ON t1.Ratio = t2.Ratio
ORDER BY
    Campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

SELECT
    t1.Year, COUNT(*) AS Campuses
FROM
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        enrollments.Year = 2003
    GROUP BY
        Campus, enrollments.Year) t1
JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        enrollments.Year = 2002
    GROUP BY
        Campus, enrollments.Year) t2 ON t1.Campus = t2.Campus AND t1.Ratio > t2.Ratio
GROUP BY
    t1.Year
UNION
SELECT
    t1.Year, COUNT(*) AS Campuses
FROM
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        enrollments.Year = 2004
    GROUP BY
        Campus, enrollments.Year) t1
JOIN
    (SELECT
        Campus, enrollments.Year, ROUND(SUM(enrollments.FTE / faculty.FTE), 2) AS Ratio
    FROM
        campuses
    JOIN
        enrollments ON enrollments.CampusId = Id
    JOIN
        faculty ON faculty.CampusId = Id AND enrollments.Year = faculty.Year
    WHERE
        enrollments.Year = 2003
    GROUP BY
        Campus, enrollments.Year) t2 ON t1.Campus = t2.Campus AND t1.Ratio > t2.Ratio
GROUP BY
    t1.Year
ORDER BY
    Year;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

SELECT
    State
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, COUNT(*) As Num
        FROM
            marathon
        GROUP BY
            State) AS t1) AS t1
CROSS JOIN
    (SELECT
        State, COUNT(*) As Num
    FROM
        marathon
    GROUP BY
        State) AS t2 ON t1.Num = t2.Num
ORDER BY
    State;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

SELECT
    t1.Town
FROM
    (SELECT
        Town, COUNT(*) AS MNum
    FROM
        marathon
    WHERE
        State = 'RI' AND Sex = 'M'
    GROUP BY
        Town) AS t1
JOIN
    (SELECT
        Town, COUNT(*) AS FNum
    FROM
        marathon
    WHERE
        State = 'RI' AND Sex = 'F'
    GROUP BY
        Town) AS t2 ON t1.Town = t2.Town
WHERE
    FNum > MNum
ORDER BY
    t1.Town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'CT') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'CT') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'FL') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'FL') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'IN') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'IN') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'MA') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'MA') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'MO') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'MO') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'NC') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'NC') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'NH') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'NH') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'NJ') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'NJ') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'PA') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'PA') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'RI') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'RI') AS t2 ON t1.Num = t2.Num
UNION
SELECT
    t2.State, t2.AgeGroup, t2.Sex, t2.Num
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            State, AgeGroup, Sex, COUNT(*) AS Num
        FROM
            marathon
        GROUP BY
            State, AgeGroup, Sex
        HAVING
            State = 'VT') AS t1) AS t1
CROSS JOIN
    (SELECT
        State, AgeGroup, Sex, COUNT(*) AS Num
    FROM
        marathon
    GROUP BY
        State, AgeGroup, Sex
    HAVING
        State = 'VT') AS t2 ON t1.Num = t2.Num
ORDER BY
    State, AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
SELECT
    Place, FirstName, LastName
FROM
    (SELECT
        ROW_NUMBER() OVER (
		    ORDER BY Pace
	    ) rowNum,
        Pace, Place, FirstName, LastName
    FROM
        marathon
    WHERE
        Sex = 'F'
    GROUP BY
        Pace, Place, FirstName, LastName
    ORDER BY
        Pace, Place) AS t1
WHERE
    rowNum = 30;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

SELECT
    t1.Town, Men, Women
FROM
    (SELECT
        marathon.Town, IFNULL(t1.Town, 0) AS Men
    FROM
        marathon
    LEFT JOIN
        (SELECT
            Town
        FROM
            marathon
        WHERE
            State = 'CT' AND Sex = 'M'
        GROUP BY
            Town) AS t1 ON t1.Town = marathon.Town
    WHERE
        State = 'CT' AND ISNULL(t1.Town)
    GROUP BY
        marathon.Town, t1.Town
    UNION  
    SELECT
        Town, COUNT(*) AS Men
    FROM
        marathon
    WHERE
        State = 'CT' AND Sex = 'M'
    GROUP BY
        Town) AS t1
JOIN
    (SELECT
        marathon.Town, IFNULL(t1.Town, 0) AS Women
    FROM
        marathon
    LEFT JOIN
        (SELECT
            Town
        FROM
            marathon
        WHERE
            State = 'CT' AND Sex = 'F'
        GROUP BY
            Town) AS t1 ON t1.Town = marathon.Town
    WHERE
        State = 'CT' AND ISNULL(t1.Town)
    GROUP BY
        marathon.Town, t1.Town
    UNION  
    SELECT
        Town, COUNT(*) AS Women
    FROM
        marathon
    WHERE
        State = 'CT' AND Sex = 'F'
    GROUP BY
        Town) AS t2 ON t1.Town = t2.Town
JOIN
    (SELECT
        Town, COUNT(*) AS Total
    FROM
        marathon
    WHERE
        State = 'CT'
    GROUP BY
        Town) AS t3 ON t1.Town = t3.Town AND t2.Town = t3.Town
ORDER BY
    Total DESC, t1.Town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

SELECT
    FirstName
FROM
    Band
WHERE
    LastName NOT IN (SELECT
                        LastName
                    FROM
                        Band
                    JOIN
                        Instruments ON Id = Bandmate
                    WHERE
                        Instrument = 'accordion'
                    GROUP BY
                        LastName);


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

SELECT
    Title
FROM
    Songs
WHERE
    SongId NOT IN (SELECT Song FROM Vocals);


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
SELECT
    Title
FROM
    (SELECT
        Max(Total) AS Total
    FROM
        (SELECT
            Title, COUNT(*) AS Total
        FROM
            Songs
        JOIN
            Instruments ON Song = SongId
        GROUP BY
            Title) AS t1) AS t1
JOIN
    (SELECT
        Title, COUNT(*) AS Total
    FROM
        Songs
    JOIN
        Instruments ON Song = SongId
    GROUP BY
        Title) AS t2 ON t1.Total = t2.Total
ORDER BY
    Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

SELECT
    t2.FirstName, t2.instrument, t1.NUM
FROM
    (SELECT
        MAX(NUM) AS NUM
    FROM
        (SELECT
            FirstName, Instrument, COUNT(*) AS NUM
        FROM
            Band
        JOIN
            Instruments ON Bandmate = Id
        WHERE
            FirstName = 'Anne-Marit'
        GROUP BY
            FirstName, Instrument) AS t1) AS t1
JOIN
    (SELECT
        FirstName, Instrument, COUNT(*) AS NUM
    FROM
        Band
    JOIN
        Instruments ON Bandmate = Id
    WHERE
        FirstName = 'Anne-Marit'
    GROUP BY
        FirstName, Instrument) AS t2 ON t1.NUM = t2.NUM
UNION
SELECT
    t2.FirstName, t2.instrument, t1.NUM
FROM
    (SELECT
        MAX(NUM) AS NUM
    FROM
        (SELECT
            FirstName, Instrument, COUNT(*) AS NUM
        FROM
            Band
        JOIN
            Instruments ON Bandmate = Id
        WHERE
            FirstName = 'Marianne'
        GROUP BY
            FirstName, Instrument) AS t1) AS t1
JOIN
    (SELECT
        FirstName, Instrument, COUNT(*) AS NUM
    FROM
        Band
    JOIN
        Instruments ON Bandmate = Id
    WHERE
        FirstName = 'Marianne'
    GROUP BY
        FirstName, Instrument) AS t2 ON t1.NUM = t2.NUM
UNION
SELECT
    t2.FirstName, t2.instrument, t1.NUM
FROM
    (SELECT
        MAX(NUM) AS NUM
    FROM
        (SELECT
            FirstName, Instrument, COUNT(*) AS NUM
        FROM
            Band
        JOIN
            Instruments ON Bandmate = Id
        WHERE
            FirstName = 'Solveig'
        GROUP BY
            FirstName, Instrument) AS t1) AS t1
JOIN
    (SELECT
        FirstName, Instrument, COUNT(*) AS NUM
    FROM
        Band
    JOIN
        Instruments ON Bandmate = Id
    WHERE
        FirstName = 'Solveig'
    GROUP BY
        FirstName, Instrument) AS t2 ON t1.NUM = t2.NUM
UNION
SELECT
    t2.FirstName, t2.instrument, t1.NUM
FROM
    (SELECT
        MAX(NUM) AS NUM
    FROM
        (SELECT
            FirstName, Instrument, COUNT(*) AS NUM
        FROM
            Band
        JOIN
            Instruments ON Bandmate = Id
        WHERE
            FirstName = 'Turid'
        GROUP BY
            FirstName, Instrument) AS t1) AS t1
JOIN
    (SELECT
        FirstName, Instrument, COUNT(*) AS NUM
    FROM
        Band
    JOIN
        Instruments ON Bandmate = Id
    WHERE
        FirstName = 'Turid'
    GROUP BY
        FirstName, Instrument) AS t2 ON t1.NUM = t2.NUM
ORDER BY
    FirstName, Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
SELECT
    Instrument
FROM
    Instruments
WHERE
    Instrument NOT IN (SELECT
                          Instrument
                      FROM
                          Band
                      JOIN
                          Instruments ON Bandmate = Id
                      WHERE
                          FirstName != 'Anne-Marit'
                      GROUP BY
                          Instrument)
ORDER BY
    Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

SELECT
    FirstName
FROM
    (SELECT
        MAX(Num) AS NUM
    FROM
        (SELECT
            FirstName, COUNT(*) AS Num
        FROM
            (SELECT
                FirstName, Instrument
            FROM
                Band
            JOIN
                Instruments ON Bandmate = Id
            GROUP BY
                FirstName, Instrument) AS t1
        GROUP BY
            FirstName) AS t1) AS t1
JOIN
    (SELECT
        FirstName, COUNT(*) AS Num
    FROM
        (SELECT
            FirstName, Instrument
        FROM
            Band
        JOIN
            Instruments ON Bandmate = Id
        GROUP BY
            FirstName, Instrument) AS t1
    GROUP BY
        FirstName) AS t2 ON t1.Num = t2.NUM
ORDER BY
    FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
SELECT
    Instrument
FROM
    (SELECT
        MAX(NUM) AS NUM
    FROM
        (SELECT
            Instrument, COUNT(*) AS NUM
        FROM
            Instruments
        JOIN
            Songs ON SongId = Song
        GROUP BY
            Instrument) AS t1) AS t1
JOIN
    (SELECT
        Instrument, COUNT(*) AS NUM
    FROM
        Instruments
    JOIN
        Songs ON SongId = Song
    GROUP BY
        Instrument) AS t2 ON t1.NUM = t2.NUM
ORDER BY
    Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

SELECT
    t2.FirstName
FROM
    (SELECT
        MAX(Num) AS Num
    FROM
        (SELECT
            FirstName, COUNT(*) AS Num
        FROM
            Band
        JOIN
            Performance ON Bandmate = Id
        WHERE
            StagePosition = 'center'
        GROUP BY
            FirstName) AS t1) AS t1
JOIN 
    (SELECT
        FirstName, COUNT(*) AS Num
    FROM
        Band
    JOIN
        Performance ON Bandmate = Id
    WHERE
        StagePosition = 'center'
    GROUP BY
        FirstName) AS t2 ON t1.Num = t2.Num
ORDER BY
    FirstName;


