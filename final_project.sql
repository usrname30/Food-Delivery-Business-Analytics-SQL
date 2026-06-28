CREATE DATABASE IF NOT EXISTS Food_DeliveryDB;
USE Food_DeliveryDB;
SHOW TABLES;

SELECT COUNT(*) AS Total_Records
FROM Orders;
SELECT *
FROM Orders
LIMIT 10;
SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;
SELECT
SUM(Customer_ID IS NULL) AS CustomerID_Null,
SUM(Restaurant_ID IS NULL) AS RestaurantID_Null,
SUM(Order_Value IS NULL) AS OrderValue_Null,
SUM(Final_Amount IS NULL) AS FinalAmount_Null,
SUM(Customer_Rating IS NULL) AS CustomerRating_Null
FROM Orders;

SELECT *
FROM Orders
WHERE Customer_Rating NOT BETWEEN 1 AND 5
   OR Restaurant_Rating NOT BETWEEN 1 AND 5;
SELECT *
FROM Orders
WHERE Order_Value < 0
   OR Delivery_Fee < 0
   OR Distance_km < 0
   OR Delivery_Time_Minutes < 0;
   
SELECT
    Order_Status,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Order_Status;

SELECT
    Payment_Mode,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Payment_Mode;

DROP INDEX idx_customer ON Orders;
CREATE INDEX idx_customer
ON Orders(Customer_ID);
DROP INDEX idx_restaurant ON orders;
CREATE INDEX idx_restaurant
ON Orders(Restaurant_ID);
DROP INDEX idx_payment ON orders;

CREATE INDEX idx_payment
ON Orders(Payment_Mode(20));

SHOW INDEX FROM Orders;

SELECT
MIN(Order_Date) AS First_Order,
MAX(Order_Date) AS Last_Order
FROM Orders;

SELECT
COUNT(*) AS Total_Orders,
COUNT(DISTINCT Customer_ID) AS Total_Customers,
COUNT(DISTINCT Restaurant_ID) AS Total_Restaurants,
ROUND(SUM(Final_Amount),2) AS Total_Revenue,
ROUND(AVG(Final_Amount),2) AS Average_Order_Value
FROM Orders;

SELECT
City,
COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Orders
GROUP BY City
ORDER BY Total_Customers DESC;

SELECT
Cuisine,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Cuisine
ORDER BY Total_Orders DESC;

SELECT
Vehicle_Type,
COUNT(*) AS Total_Deliveries
FROM Orders
GROUP BY Vehicle_Type
ORDER BY Total_Deliveries DESC;

SELECT
Payment_Mode,
ROUND(SUM(Final_Amount),2) AS Revenue
FROM Orders
GROUP BY Payment_Mode
ORDER BY Revenue DESC;

SELECT
ROUND(AVG(Delivery_Time_Minutes),2) AS Avg_Delivery_Time,
ROUND(AVG(Distance_km),2) AS Avg_Distance,
ROUND(AVG(Customer_Rating),2) AS Avg_Customer_Rating
FROM Orders;

DROP VIEW IF EXISTS Customer_Spending_Report;
CREATE VIEW Customer_Spending_Report AS
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Final_Amount) AS Total_Spent,
    ROUND(AVG(Final_Amount),2) AS Average_Order_Value
FROM Orders
GROUP BY Customer_ID, Customer_Name;



DROP VIEW IF EXISTS Restaurant_performance;
CREATE VIEW Restaurant_Performance AS
SELECT
    Restaurant_ID,
    Restaurant_Name,
    Cuisine,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Final_Amount) AS Total_Revenue
FROM Orders
GROUP BY Restaurant_ID, Restaurant_Name, Cuisine;

SELECT * FROM Restaurant_Performance;
DROP VIEW IF EXISTS City_Sales_Report;
CREATE VIEW City_Sales_Report AS
SELECT
    City,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY City;

SELECT * FROM City_Sales_Report;
DROP VIEW IF EXISTS Payment_Analysis;
CREATE VIEW Payment_Analysis AS
SELECT
    Payment_Mode,
    COUNT(Order_ID) AS Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Payment_Mode;

SELECT * FROM Payment_Analysis;
DROP VIEW IF EXISTS Delivery_Partner_Report;
CREATE VIEW Delivery_Partner_Report AS
SELECT
    Delivery_Partner,
    Vehicle_Type,
    COUNT(Order_ID) AS Deliveries,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Delivery_Partner, Vehicle_Type;

SELECT * FROM Delivery_Partner_Report;
DROP VIEW IF EXISTS Cuisine_Analysis;
CREATE VIEW Cuisine_Analysis AS
SELECT
    Cuisine,
    COUNT(Order_ID) AS Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Cuisine;
SELECT * FROM Cuisine_Analysis;
DROP VIEW IF EXISTS Customer_Rating_Report;
CREATE VIEW Customer_Rating_Report AS
SELECT
    Customer_Rating,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Customer_Rating;
SELECT * FROM Customer_Rating_Report;
DROP VIEW IF EXISTS Weather_Impact_Report;
CREATE VIEW Weather_Impact_Report AS
SELECT
    Weather,
    COUNT(Order_ID) AS Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Weather;
SELECT * FROM Weather_Impact_Report;
DROP VIEW IF EXISTS Festival_Sales_Report;
CREATE VIEW Festival_Sales_Report AS
SELECT
    Festival,
    COUNT(Order_ID) AS Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Festival;
SELECT * FROM Festival_Sales_Report;
DROP VIEW IF EXISTS Order_Status_Report;
CREATE VIEW Order_Status_Report AS
SELECT
    Order_Status,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Order_Status;
SELECT * FROM Order_Status_Report;

SHOW FULL TABLES
WHERE Table_Type='VIEW';


DROP PROCEDURE IF EXISTS GetAllOrders;

DELIMITER $$

CREATE PROCEDURE GetAllOrders()
BEGIN
    SELECT * FROM Orders;
END $$

DELIMITER ;
CALL GetAllOrders();

DROP PROCEDURE IF EXISTS CustomerOrderHistory;

DELIMITER $$

CREATE PROCEDURE CustomerOrderHistory(IN p_customer_id INT)
BEGIN
    SELECT
        Order_ID,
        Customer_Name,
        Restaurant_Name,
        Final_Amount,
        Order_Status
    FROM Orders
    WHERE Customer_ID = p_customer_id;
END $$

DELIMITER ;
CALL CustomerOrderHistory(1001);


DROP PROCEDURE IF EXISTS OrdersByCity;

DELIMITER $$

CREATE PROCEDURE OrdersByCity(IN p_city VARCHAR(100))
BEGIN
    SELECT *
    FROM Orders
    WHERE City = p_city;
END $$

DELIMITER ;
CALL OrdersByCity('Delhi');

DROP PROCEDURE IF EXISTS OrdersByPayment;

DELIMITER $$

CREATE PROCEDURE OrdersByPayment(IN p_payment VARCHAR(50))
BEGIN
    SELECT *
    FROM Orders
    WHERE Payment_Mode = p_payment;
END $$

DELIMITER ;


CALL OrdersByPayment('UPI');


DROP PROCEDURE IF EXISTS RestaurantRevenue;

DELIMITER $$

CREATE PROCEDURE RestaurantRevenue(IN p_restaurant VARCHAR(100))
BEGIN
    SELECT
        Restaurant_Name,
        COUNT(Order_ID) AS Total_Orders,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    WHERE Restaurant_Name = p_restaurant
    GROUP BY Restaurant_Name;
END $$

DELIMITER ;
CALL RestaurantRevenue('Pizza Hut');

DROP PROCEDURE IF EXISTS OrdersByStatus;

DELIMITER $$

CREATE PROCEDURE OrdersByStatus(IN p_status VARCHAR(50))
BEGIN
    SELECT *
    FROM Orders
    WHERE Order_Status = p_status;
END $$

DELIMITER ;
CALL OrdersByStatus('Delivered');

DROP PROCEDURE IF EXISTS TopRatedRestaurants;

DELIMITER $$

CREATE PROCEDURE TopRatedRestaurants()
BEGIN
    SELECT
        Restaurant_Name,
        AVG(Restaurant_Rating) AS Average_Rating
    FROM Orders
    GROUP BY Restaurant_Name
    ORDER BY Average_Rating DESC
    LIMIT 10;
END $$

DELIMITER ;
CALL TopRatedRestaurants();

DROP PROCEDURE IF EXISTS HighestSpendingCustomers;

DELIMITER $$

CREATE PROCEDURE HighestSpendingCustomers()
BEGIN
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Final_Amount) AS Total_Spent
    FROM Orders
    GROUP BY Customer_ID, Customer_Name
    ORDER BY Total_Spent DESC
    LIMIT 10;
END $$

DELIMITER ;
CALL HighestSpendingCustomers();

DROP PROCEDURE IF EXISTS DeliveryPartnerPerformance;

DELIMITER $$

CREATE PROCEDURE DeliveryPartnerPerformance()
BEGIN
    SELECT
        Delivery_Partner,
        COUNT(Order_ID) AS Deliveries,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Delivery_Partner
    ORDER BY Deliveries DESC;
END $$

DELIMITER ;
CALL DeliveryPartnerPerformance();

DROP PROCEDURE IF EXISTS BusinessSummary;

DELIMITER $$

CREATE PROCEDURE BusinessSummary()
BEGIN
    SELECT
        COUNT(Order_ID) AS Total_Orders,
        COUNT(DISTINCT Customer_ID) AS Total_Customers,
        COUNT(DISTINCT Restaurant_ID) AS Total_Restaurants,
        SUM(Final_Amount) AS Total_Revenue,
        AVG(Final_Amount) AS Average_Order_Value
    FROM Orders;
END $$

DELIMITER ;
CALL BusinessSummary();


SELECT
    Customer_ID,
    Customer_Name,
    SUM(Final_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Spent DESC
LIMIT 10;

SELECT
    Restaurant_Name,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Restaurant_Name
ORDER BY Revenue DESC
LIMIT 10;

SELECT
    City,
    SUM(Final_Amount) AS Total_Revenue
FROM Orders
GROUP BY City
ORDER BY Total_Revenue DESC;

SELECT
    Cuisine,
    COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Cuisine
ORDER BY Total_Orders DESC;

SELECT
    Restaurant_Name,
    ROUND(AVG(Customer_Rating),2) AS Average_Rating
FROM Orders
GROUP BY Restaurant_Name
ORDER BY Average_Rating DESC;

SELECT
    Payment_Mode,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Payment_Mode
ORDER BY Revenue DESC;

SELECT
    Vehicle_Type,
    ROUND(AVG(Delivery_Time_Minutes),2) AS Average_Delivery_Time,
    COUNT(Order_ID) AS Total_Deliveries
FROM Orders
GROUP BY Vehicle_Type;

SELECT
    Weather,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Weather;

SELECT
    Festival,
    COUNT(Order_ID) AS Orders,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Festival;

SELECT
    Order_Status,
    COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Order_Status;

SELECT
    City,
    ROUND(AVG(Final_Amount),2) AS Average_Order_Value
FROM Orders
GROUP BY City
ORDER BY Average_Order_Value DESC;

SELECT
    Delivery_Partner,
    COUNT(Order_ID) AS Total_Deliveries,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Delivery_Partner
ORDER BY Total_Deliveries DESC
LIMIT 10;


WITH CustomerRevenue AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Final_Amount) AS Total_Spent
    FROM Orders
    GROUP BY Customer_ID, Customer_Name
)
SELECT *
FROM CustomerRevenue
ORDER BY Total_Spent DESC
LIMIT 10;

WITH RestaurantRevenue AS
(
    SELECT
        Restaurant_Name,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Restaurant_Name
)
SELECT *
FROM RestaurantRevenue
ORDER BY Revenue DESC
LIMIT 10;

WITH CityRevenue AS
(
    SELECT
        City,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY City
)
SELECT *
FROM CityRevenue
ORDER BY Revenue DESC;

WITH RestaurantRating AS
(
    SELECT
        Restaurant_Name,
        ROUND(AVG(Customer_Rating),2) AS Avg_Rating
    FROM Orders
    GROUP BY Restaurant_Name
)
SELECT *
FROM RestaurantRating
ORDER BY Avg_Rating DESC;

WITH PartnerPerformance AS
(
    SELECT
        Delivery_Partner,
        COUNT(Order_ID) AS Deliveries,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Delivery_Partner
)
SELECT *
FROM PartnerPerformance
ORDER BY Deliveries DESC;

WITH PaymentRevenue AS
(
    SELECT
        Payment_Mode,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Payment_Mode
)
SELECT *
FROM PaymentRevenue
ORDER BY Revenue DESC;

WITH CuisineOrders AS
(
    SELECT
        Cuisine,
        COUNT(Order_ID) AS Total_Orders
    FROM Orders
    GROUP BY Cuisine
)
SELECT *
FROM CuisineOrders
ORDER BY Total_Orders DESC;

WITH WeatherReport AS
(
    SELECT
        Weather,
        COUNT(Order_ID) AS Orders,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Weather
)
SELECT *
FROM WeatherReport
ORDER BY Revenue DESC;

WITH FestivalReport AS
(
    SELECT
        Festival,
        COUNT(Order_ID) AS Orders,
        SUM(Final_Amount) AS Revenue
    FROM Orders
    GROUP BY Festival
)
SELECT *
FROM FestivalReport
ORDER BY Revenue DESC;

WITH StatusReport AS
(
    SELECT
        Order_Status,
        COUNT(Order_ID) AS Total_Orders
    FROM Orders
    GROUP BY Order_Status
)
SELECT *
FROM StatusReport
ORDER BY Total_Orders DESC;


WITH StatusReport AS
(
    SELECT
        Order_Status,
        COUNT(Order_ID) AS Total_Orders
    FROM Orders
    GROUP BY Order_Status
)
SELECT *
FROM StatusReport
ORDER BY Total_Orders DESC;

SELECT
    Customer_ID,
    Customer_Name,
    SUM(Final_Amount) AS Total_Spent,
    RANK() OVER (ORDER BY SUM(Final_Amount) DESC) AS Customer_Rank
FROM Orders
GROUP BY Customer_ID, Customer_Name;

SELECT
    Order_ID,
    Customer_ID,
    Customer_Name,
    Final_Amount,
    ROW_NUMBER() OVER (
        PARTITION BY Customer_ID
        ORDER BY Final_Amount DESC
    ) AS Order_Number
FROM Orders;

SELECT
    Order_ID,
    Final_Amount,
    SUM(Final_Amount) OVER (
        ORDER BY Order_ID
    ) AS Running_Revenue
FROM Orders;

SELECT
    Order_ID,
    Final_Amount,
    LAG(Final_Amount) OVER (
        ORDER BY Order_ID
    ) AS Previous_Order_Value
FROM Orders;

SELECT
    Order_ID,
    Final_Amount,
    LEAD(Final_Amount) OVER (
        ORDER BY Order_ID
    ) AS Next_Order_Value
FROM Orders;


DROP TRIGGER IF EXISTS trg_check_order_value;

DELIMITER $$

CREATE TRIGGER trg_check_order_value
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Order_Value < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order Value cannot be negative';
    END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_delivery_fee;

DELIMITER $$

CREATE TRIGGER trg_check_delivery_fee
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Delivery_Fee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delivery Fee cannot be negative';
    END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_customer_rating;

DELIMITER $$

CREATE TRIGGER trg_check_customer_rating
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Customer_Rating < 1 OR NEW.Customer_Rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer Rating must be between 1 and 5';
    END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_restaurant_rating;

DELIMITER $$

CREATE TRIGGER trg_check_restaurant_rating
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Restaurant_Rating < 1 OR NEW.Restaurant_Rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Restaurant Rating must be between 1 and 5';
    END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_distance;

DELIMITER $$

CREATE TRIGGER trg_check_distance
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Distance_km < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Distance cannot be negative';
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS;


SELECT
    Customer_ID,
    Customer_Name,
    SUM(Final_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID, Customer_Name
HAVING SUM(Final_Amount) >
(
    SELECT AVG(TotalSpent)
    FROM
    (
        SELECT SUM(Final_Amount) AS TotalSpent
        FROM Orders
        GROUP BY Customer_ID
    ) AS AvgCustomerSpend
)
ORDER BY Total_Spent DESC;

SELECT
    Restaurant_Name,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY Restaurant_Name
HAVING SUM(Final_Amount) >
(
    SELECT AVG(RestaurantRevenue)
    FROM
    (
        SELECT SUM(Final_Amount) AS RestaurantRevenue
        FROM Orders
        GROUP BY Restaurant_Name
    ) AS AvgRevenue
)
ORDER BY Revenue DESC;

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Restaurant_Name) AS Restaurants_Visited
FROM Orders
GROUP BY Customer_ID, Customer_Name
HAVING COUNT(DISTINCT Restaurant_Name) > 1
ORDER BY Restaurants_Visited DESC;

SELECT
    City,
    SUM(Final_Amount) AS Revenue
FROM Orders
GROUP BY City
HAVING SUM(Final_Amount) >
(
    SELECT AVG(CityRevenue)
    FROM
    (
        SELECT SUM(Final_Amount) AS CityRevenue
        FROM Orders
        GROUP BY City
    ) AS AvgCityRevenue
)
ORDER BY Revenue DESC;
SELECT
    City,
    Restaurant_Name,
    Total_Orders
FROM
(
    SELECT
        City,
        Restaurant_Name,
        COUNT(*) AS Total_Orders,
        ROW_NUMBER() OVER
        (
            PARTITION BY City
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM Orders
    GROUP BY City, Restaurant_Name
) AS RankedRestaurants
WHERE rn = 1;
