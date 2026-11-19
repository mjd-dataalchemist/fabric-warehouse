-- Silver: cabeceras de pedidos.
CREATE TABLE silver.Orders (
 OrderID INT NOT NULL, CustomerID INT NOT NULL, SalespersonPersonID INT NOT NULL,
 OrderDate DATE NOT NULL, ExpectedDeliveryDate DATE NULL,
 CustomerPurchaseOrderNumber VARCHAR(30) NULL, IsUndersupplyBackordered BIT NOT NULL
);
INSERT INTO silver.Orders
SELECT OrderID, CustomerID, SalespersonPersonID, CAST(OrderDate AS DATE),
 CAST(ExpectedDeliveryDate AS DATE), CustomerPurchaseOrderNumber, IsUndersupplyBackordered
FROM bronze.Orders;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT OrderID) AS DistinctOrders
FROM silver.Orders;
