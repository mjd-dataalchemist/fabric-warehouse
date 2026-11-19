-- Validacion: LEFT JOIN conserva todas las filas de hechos y permite detectar
-- claves dimensionales sin correspondencia.
SELECT
 SUM(CASE WHEN d.DateKey IS NULL THEN 1 ELSE 0 END) AS MissingDates,
 SUM(CASE WHEN c.CustomerKey IS NULL THEN 1 ELSE 0 END) AS MissingCustomers,
 SUM(CASE WHEN p.ProductKey IS NULL THEN 1 ELSE 0 END) AS MissingProducts,
 SUM(CASE WHEN s.SalespersonKey IS NULL THEN 1 ELSE 0 END) AS MissingSalespeople
FROM gold.FactSales f
LEFT JOIN gold.DimDate d ON f.DateKey=d.DateKey
LEFT JOIN gold.DimCustomer c ON f.CustomerKey=c.CustomerKey
LEFT JOIN gold.DimProduct p ON f.ProductKey=p.ProductKey
LEFT JOIN gold.DimSalesperson s ON f.SalespersonKey=s.SalespersonKey;
