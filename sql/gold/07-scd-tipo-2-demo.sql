/*
DEMOSTRACIÓN CONTROLADA SCD TIPO 2
Cliente de prueba: CustomerID = 1

IMPORTANTE:
- La simulación ya se ha aplicado en WH_DP600.
- CustomerKey 1 está cerrada y CustomerKey 664 es la versión actual.
- Este archivo documenta la prueba; NO vuelvas a ejecutar UPDATE/INSERT.
- No es un proceso ETL genérico ni automatizado.
*/

-- 1. Inspeccionar las versiones del cliente.
SELECT CustomerKey, CustomerID, CustomerName, StartDate, EndDate, IsCurrent
FROM gold.DimCustomer
WHERE CustomerID = 1
ORDER BY StartDate;

/*
2. OPERACIONES HISTÓRICAS YA EJECUTADAS. SOLO REFERENCIA; NO DESCOMENTAR.

UPDATE gold.DimCustomer
SET EndDate = '2026-11-19', IsCurrent = 0
WHERE CustomerID = 1 AND IsCurrent = 1;

INSERT INTO gold.DimCustomer (
    CustomerKey, CustomerID, CustomerName, CustomerCategoryID,
    BuyingGroupID, DeliveryCityID, CreditLimit,
    StandardDiscountPercentage, AccountOpenedDate,
    StartDate, EndDate, IsCurrent
)
SELECT
    664, CustomerID,
    'Tailspin Toys (Head Office) - SCD2 DEMO',
    CustomerCategoryID, BuyingGroupID, DeliveryCityID, CreditLimit,
    StandardDiscountPercentage, AccountOpenedDate,
    '2026-11-20', '9999-12-31', 1
FROM silver.Customers
WHERE CustomerID = 1;
*/

-- 3. Validar dos versiones y una única versión vigente.
SELECT
    CustomerID,
    COUNT(*) AS NumberOfVersions,
    SUM(CASE WHEN IsCurrent = 1 THEN 1 ELSE 0 END) AS CurrentVersions
FROM gold.DimCustomer
WHERE CustomerID = 1
GROUP BY CustomerID;

-- 4. Validación temporal de todas las ventas.
SELECT
    COUNT(*) AS TotalFactRows,
    SUM(CASE WHEN d.CustomerKey IS NULL THEN 1 ELSE 0 END) AS MissingTemporalCustomer,
    SUM(CASE
        WHEN d.CustomerKey IS NOT NULL AND d.CustomerKey <> f.CustomerKey
        THEN 1 ELSE 0
    END) AS IncorrectCustomerVersion
FROM gold.FactSales f
INNER JOIN silver.Orders o ON f.OrderID = o.OrderID
LEFT JOIN gold.DimCustomer d
    ON d.CustomerID = (
        SELECT c.CustomerID
        FROM gold.DimCustomer c
        WHERE c.CustomerKey = f.CustomerKey
    )
   AND o.OrderDate >= d.StartDate
   AND o.OrderDate <= d.EndDate;

-- 5. Ventas del cliente 1: deben seguir usando CustomerKey 1,
-- porque todas son anteriores al cambio simulado del 20/11/2026.
SELECT
    COUNT(*) AS TotalSalesLines,
    MIN(o.OrderDate) AS FirstOrderDate,
    MAX(o.OrderDate) AS LastOrderDate,
    COUNT(DISTINCT f.CustomerKey) AS CustomerVersionsUsed
FROM gold.FactSales f
INNER JOIN silver.Orders o ON f.OrderID = o.OrderID
WHERE f.CustomerKey IN (1, 664);
