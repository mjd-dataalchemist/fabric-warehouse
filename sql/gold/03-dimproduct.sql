-- Gold: dimension producto.
CREATE TABLE gold.DimProduct (
 ProductKey INT NOT NULL, StockItemID INT NOT NULL, ProductName VARCHAR(100) NOT NULL,
 SupplierID INT NULL, ColorID INT NULL, UnitPackageID INT NOT NULL,
 OuterPackageID INT NOT NULL, Brand VARCHAR(20) NULL, Size VARCHAR(20) NULL,
 LeadTimeDays INT NOT NULL, IsChillerStock BIT NOT NULL, TaxRate DECIMAL(5,2) NOT NULL,
 UnitPrice DECIMAL(18,2) NOT NULL, RecommendedRetailPrice DECIMAL(18,2) NULL,
 TypicalWeightPerUnit DECIMAL(18,3) NOT NULL
);
INSERT INTO gold.DimProduct
SELECT ROW_NUMBER() OVER (ORDER BY StockItemID), StockItemID, StockItemName,
 SupplierID, ColorID, UnitPackageID, OuterPackageID, Brand, Size, LeadTimeDays,
 IsChillerStock, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit
FROM silver.Products;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT ProductKey) AS DistinctProductKeys,
 COUNT(DISTINCT StockItemID) AS DistinctProducts FROM gold.DimProduct;
