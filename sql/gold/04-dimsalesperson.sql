-- Gold: dimension vendedor.
CREATE TABLE gold.DimSalesperson (
 SalespersonKey INT NOT NULL, PersonID INT NOT NULL, SalespersonName VARCHAR(100) NOT NULL
);
INSERT INTO gold.DimSalesperson
SELECT ROW_NUMBER() OVER (ORDER BY PersonID), PersonID, FullName
FROM bronze.People WHERE IsSalesperson=1;
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT PersonID) AS DistinctSalespeople
FROM gold.DimSalesperson;
