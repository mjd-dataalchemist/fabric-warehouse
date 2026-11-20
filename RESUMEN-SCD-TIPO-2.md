# Resumen rápido: simulación SCD Tipo 2

SCD Tipo 2 (Slowly Changing Dimension Type 2) conserva el historial de cambios de una dimensión creando una fila nueva cuando cambia un atributo que queremos historificar.

En nuestra prueba:
1. El cliente 1 tenía una sola versión: `CustomerKey = 1`.
2. Simulamos un cambio de nombre efectivo el 20/11/2026.
3. Cerramos la versión antigua el 19/11/2026 (`IsCurrent = 0`).
4. Insertamos una nueva versión con `CustomerKey = 664` y `IsCurrent = 1`.
5. Las ventas históricas siguen apuntando a la clave 1 porque ocurrieron antes del cambio.

Idea clave: `CustomerID` identifica al cliente de negocio; `CustomerKey` identifica una versión concreta de ese cliente en el almacén analítico.

La validación temporal de las 231.412 filas de FactSales devolvió cero ventas sin versión temporal y cero claves de cliente incorrectas.

La prueba es manual y controlada: demuestra el patrón SCD Tipo 2, pero no constituye todavía un proceso ETL automatizado.
