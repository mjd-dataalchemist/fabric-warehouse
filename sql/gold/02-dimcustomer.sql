-- Gold: dimension cliente. Estructura preparada para SCD Tipo 2.
-- IMPORTANTE: esta carga inicial NO implementa aun el proceso de historificacion.
CREATE TABLE gold.DimCustomer (
 CustomerKey INT NOT NULL, CustomerID INT NOT NULL, CustomerName VARCHAR(50) NOT NULL,
 CustomerCategoryID INT NOT NULL, BuyingGroupID INT NULL, DeliveryCityID INT NOT NULL,
 CreditLimit DECIMAL(18,2) NULL, StandardDiscountPercentage DECIMAL(5,2) NOT NULL,
 AccountOpenedDate DATE NOT NULL, StartDate DATE NOT NULL, EndDate DATE NOT NULL,
 IsCurrent BIT NOT NULL
);
INSERT INTO gold.DimCustomer
SELECT ROW_NUMBER() OVER (ORDER BY CustomerID), CustomerID, CustomerName,
 CustomerCategoryID, BuyingGroupID, DeliveryCityID, CreditLimit,
 StandardDiscountPercentage, AccountOpenedDate, AccountOpenedDate,
 CAST('9999-12-31' AS DATE), 1
FROM silver.Customers;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT CustomerKey) AS DistinctCustomerKeys,
 COUNT(DISTINCT CustomerID) AS DistinctCustomers,
 SUM(CASE WHEN IsCurrent=1 THEN 1 ELSE 0 END) AS CurrentCustomers
FROM gold.DimCustomer;
