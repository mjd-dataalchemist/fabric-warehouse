-- Silver: lineas de pedido. Grano: una fila por OrderLineID.
CREATE TABLE silver.OrderLines (
 OrderLineID INT NOT NULL, OrderID INT NOT NULL, StockItemID INT NOT NULL,
 Description VARCHAR(100) NULL, PackageTypeID INT NOT NULL, Quantity INT NOT NULL,
 UnitPrice DECIMAL(18,2) NOT NULL, TaxRate DECIMAL(5,2) NOT NULL,
 PickedQuantity INT NOT NULL
);
INSERT INTO silver.OrderLines
SELECT OrderLineID, OrderID, StockItemID, Description, PackageTypeID,
 Quantity, UnitPrice, TaxRate, PickedQuantity
FROM bronze.OrderLines;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT OrderLineID) AS DistinctOrderLines
FROM silver.OrderLines;
