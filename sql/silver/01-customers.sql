-- Silver: clientes. Carga inicial; no ejecutar de nuevo sin limpiar el destino.
CREATE TABLE silver.Customers (
 CustomerID INT NOT NULL, CustomerName VARCHAR(50) NOT NULL,
 CustomerCategoryID INT NOT NULL, BuyingGroupID INT NULL, DeliveryCityID INT NOT NULL,
 CreditLimit DECIMAL(18,2) NULL, AccountOpenedDate DATE NOT NULL,
 StandardDiscountPercentage DECIMAL(5,2) NOT NULL, IsStatementSent BIT NOT NULL,
 IsOnCreditHold BIT NOT NULL, PaymentDays INT NOT NULL, PhoneNumber VARCHAR(20) NULL,
 FaxNumber VARCHAR(20) NULL, WebsiteURL VARCHAR(70) NULL,
 DeliveryAddressLine1 VARCHAR(20) NULL, DeliveryAddressLine2 VARCHAR(35) NULL,
 DeliveryPostalCode VARCHAR(10) NULL, PostalAddressLine1 VARCHAR(20) NULL,
 PostalAddressLine2 VARCHAR(30) NULL, PostalPostalCode VARCHAR(10) NULL
);
INSERT INTO silver.Customers
SELECT CustomerID, CustomerName, CustomerCategoryID, BuyingGroupID, DeliveryCityID,
 CreditLimit, CAST(AccountOpenedDate AS DATE), StandardDiscountPercentage,
 IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, WebsiteURL,
 DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode,
 PostalAddressLine1, PostalAddressLine2, PostalPostalCode
FROM bronze.Customers;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT CustomerID) AS DistinctCustomers
FROM silver.Customers;
