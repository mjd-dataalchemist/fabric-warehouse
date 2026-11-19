# Decisiones técnicas y limitaciones conocidas

Este documento registra decisiones tomadas para que la PoC funcione y deja explícito qué aspectos no deben trasladarse sin revisión a producción.

## Conectividad y certificado TLS

Durante la configuración de `CN_SQLSERVER_WWIMPORTERS_DEV` se desactivó temporalmente la validación de confianza del certificado debido a un problema con el certificado TLS local.

- **Motivo:** desbloquear la conectividad en el entorno de desarrollo.
- **Alcance:** exclusivamente laboratorio.
- **En producción:** instalar y configurar un certificado válido y confiable, y mantener la validación TLS habilitada.

## Extracción y política RLS del origen

Una política de seguridad a nivel de fila en `Sales.Customers` impedía que el usuario de extracción obtuviera las filas necesarias para la PoC. Se deshabilitó temporalmente en el origen para completar la carga.

- **Motivo:** permitir la extracción completa de datos de demostración.
- **Alcance:** exclusivamente PoC.
- **En producción:** mantener una estrategia de acceso autorizada y no deshabilitar controles de seguridad para facilitar una carga. La seguridad analítica se debe diseñar en las capas adecuadas.
- La RLS/OLS del modelo semántico Power BI está pendiente y no equivale a la seguridad aplicada directamente en el Warehouse.

## Duplicados en Bronze

Se observaron tres copias idénticas de cada uno de los 227 productos en Bronze, coherentes con ejecuciones repetidas de una carga en modo append. La transformación de `silver.Products` elimina duplicados idénticos.

- Bronze se conserva como zona de aterrizaje.
- La estrategia de refresco debe definirse explícitamente para cada carga.
- Una carga completa repetida en modo append puede duplicar datos.
- SCD Tipo 2 es un patrón de gestión de cambios históricos en dimensiones; no es una estrategia de refresco de una copia completa.

## Datos geográficos

Algunas columnas espaciales de WideWorldImporters causaron dificultades de extracción por su tamaño o tipo de dato. Se crearon vistas en el esquema `fabric_export` para exponer representaciones WKT cuando resultaba viable. En tablas con geometrías extensas se omitieron las geometrías de la extracción de esta PoC.

Esto reduce el alcance geoespacial del laboratorio; no significa que esos datos deban descartarse en una solución productiva.

## Alcance del modelo dimensional

La dimensión de cliente está preparada estructuralmente para SCD Tipo 2, pero aún no implementa el ciclo de vida de versiones. La tabla de hechos se cargó usando la versión actual del cliente. La resolución histórica de claves de dimensión según la fecha del hecho queda pendiente.

## Principio general

Las simplificaciones anteriores son decisiones de laboratorio documentadas, no recomendaciones de seguridad u operación para producción.
