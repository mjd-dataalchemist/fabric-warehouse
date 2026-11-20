# Demostración SCD Tipo 2 en DimCustomer

## Objetivo

Demostrar cómo conservar el historial de cambios de un cliente mediante claves sustitutas y periodos de vigencia, sin sobrescribir la versión anterior.

La prueba se realizó de forma controlada sobre `CustomerID = 1` en `WH_DP600`.

## Estado inicial

| CustomerKey | CustomerID | CustomerName | StartDate | EndDate | IsCurrent |
|---:|---:|---|---|---|---:|
| 1 | 1 | Tailspin Toys (Head Office) | 2013-01-01 | 9999-12-31 | 1 |

La comparación con `silver.Customers` confirmó que los atributos iniciales de Gold coincidían con el origen Silver.

## Simulación

Se simuló un cambio de nombre con fecha efectiva **2026-11-20**, sin modificar SQL Server ni `silver.Customers`.

1. Se cerró la versión anterior: `EndDate = 2026-11-19` e `IsCurrent = 0` para `CustomerKey = 1`.
2. Se insertó una nueva versión con `CustomerKey = 664`, el nombre `Tailspin Toys (Head Office) - SCD2 DEMO`, `StartDate = 2026-11-20`, `EndDate = 9999-12-31` e `IsCurrent = 1`.

`CustomerKey` no era una columna `IDENTITY`; se asignó manualmente 664 después de comprobar que 663 era el máximo existente.

## Resultado

| CustomerKey | CustomerID | CustomerName | StartDate | EndDate | IsCurrent |
|---:|---:|---|---|---|---:|
| 1 | 1 | Tailspin Toys (Head Office) | 2013-01-01 | 2026-11-19 | 0 |
| 664 | 1 | Tailspin Toys (Head Office) - SCD2 DEMO | 2026-11-20 | 9999-12-31 | 1 |

`CustomerID` identifica al cliente de negocio; `CustomerKey` identifica una versión concreta en el almacén analítico.

## Relación con FactSales

La versión correcta se resuelve según la fecha del pedido:

`StartDate <= OrderDate <= EndDate`

La validación de la tabla de hechos devolvió:

| TotalFactRows | MissingTemporalCustomer | IncorrectCustomerVersion |
|---:|---:|---:|
| 231412 | 0 | 0 |

Las 412 líneas de venta del cliente 1 utilizan `CustomerKey = 1`. Su última venta fue el **2016-05-27**, anterior al cambio simulado del **2026-11-20**. Por tanto, deben permanecer asociadas a la versión histórica.

## Alcance real de la demostración

**Demuestra:** cierre de una versión anterior, inserción de una nueva versión con clave sustituta diferente, control de vigencia y validación temporal de las claves de cliente en FactSales.

**No demuestra:** detección automática de cambios para todos los clientes, ETL incremental reutilizable, tratamiento automatizado de múltiples cambios, reintentos o cargas concurrentes.

Fue una simulación manual y controlada, no un proceso productivo automatizado.

## Reproducción y seguridad

`sql/gold/07-scd-tipo-2-demo.sql` conserva las consultas de inspección y validación. Las sentencias `UPDATE` e `INSERT` ya ejecutadas están comentadas como referencia histórica.

**No las descomentes ni ejecutes de nuevo sobre el estado actual.** Para repetir la prueba, restaura una copia limpia de la dimensión o utiliza otro cliente de prueba con una sola versión vigente.

## Evidencias

Guardar capturas reales en:
- `screenshots/warehouse/04-dimcustomer-scd2.png`
- `screenshots/warehouse/05-factsales-temporal-validation.png`
