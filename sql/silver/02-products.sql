-- Silver: productos. DISTINCT elimina las tres copias identicas observadas en Bronze.
CREATE TABLE silver.Products (
 StockItemID INT NOT NULL, StockItemName VARCHAR(100) NOT NULL,
 SupplierID INT NULL, ColorID INT NULL, UnitPackageID INT NOT NULL,
 OuterPackageID INT NOT NULL, Brand VARCHAR(20) NULL, Size VARCHAR(20) NULL,
 LeadTimeDays INT NOT NULL, QuantityPerOuter INT NOT NULL, IsChillerStock BIT NOT NULL,
 TaxRate DECIMAL(5,2) NOT NULL, UnitPrice DECIMAL(18,2) NOT NULL,
 RecommendedRetailPrice DECIMAL(18,2) NULL, TypicalWeightPerUnit DECIMAL(18,3) NOT NULL
);
INSERT INTO silver.Products
SELECT DISTINCT StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID,
 OuterPackageID, Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock,
 TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit
FROM bronze.StockItems;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT StockItemID) AS DistinctProducts
FROM silver.Products;
