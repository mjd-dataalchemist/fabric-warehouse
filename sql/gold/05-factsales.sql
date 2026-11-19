-- Gold: tabla de hechos transaccional. Grano: una fila por OrderLineID.
-- La carga usa la version actual del cliente; el proceso SCD Tipo 2 queda pendiente.
CREATE TABLE gold.FactSales (
 OrderLineID INT NOT NULL, OrderID INT NOT NULL, DateKey INT NOT NULL,
 CustomerKey INT NOT NULL, ProductKey INT NOT NULL, SalespersonKey INT NOT NULL,
 Quantity INT NOT NULL, UnitPrice DECIMAL(18,2) NOT NULL, TaxRate DECIMAL(5,2) NOT NULL,
 SalesAmount DECIMAL(18,2) NOT NULL, TaxAmount DECIMAL(18,2) NOT NULL,
 TotalAmount DECIMAL(18,2) NOT NULL
);
INSERT INTO gold.FactSales
SELECT ol.OrderLineID, ol.OrderID, d.DateKey, dc.CustomerKey, dp.ProductKey,
 ds.SalespersonKey, ol.Quantity, ol.UnitPrice, ol.TaxRate,
 CAST(ol.Quantity*ol.UnitPrice AS DECIMAL(18,2)),
 CAST(ol.Quantity*ol.UnitPrice*ol.TaxRate/100.0 AS DECIMAL(18,2)),
 CAST(ol.Quantity*ol.UnitPrice*(1+ol.TaxRate/100.0) AS DECIMAL(18,2))
FROM silver.OrderLines ol
INNER JOIN silver.Orders o ON ol.OrderID=o.OrderID
INNER JOIN gold.DimDate d ON o.OrderDate=d.FullDate
INNER JOIN gold.DimCustomer dc ON o.CustomerID=dc.CustomerID AND dc.IsCurrent=1
INNER JOIN gold.DimProduct dp ON ol.StockItemID=dp.StockItemID
INNER JOIN gold.DimSalesperson ds ON o.SalespersonPersonID=ds.PersonID;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT OrderLineID) AS DistinctOrderLines,
 SUM(SalesAmount) AS TotalSales, SUM(TaxAmount) AS TotalTax,
 SUM(TotalAmount) AS TotalAmount FROM gold.FactSales;
