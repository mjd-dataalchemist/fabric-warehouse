# Evidencias de la arquitectura actual

Esta lista sirve para completar la carpeta `screenshots/` con capturas reales del entorno. No se deben crear capturas ficticias ni incluir secretos, contraseñas, tokens o cadenas de conexión sensibles.

## Capturas prioritarias

| Archivo sugerido | Qué debe mostrar | Carpeta |
|---|---|---|
| `01-workspace-fabric.png` | Workspace `DP-600` y sus elementos principales | `screenshots/architecture/` |
| `02-warehouse-schemas.png` | `WH_DP600` y los esquemas `bronze`, `silver`, `gold` | `screenshots/warehouse/` |
| `03-gateway-online.png` | Gateway `GW_DP600_DEV` en estado disponible/en línea | `screenshots/architecture/` |
| `04-copy-job-overview.png` | Copy Job `CJ_01_SQLServer_to_Bronze` y su configuración general | `screenshots/data-factory/` |
| `05-copy-job-run.png` | Ejecución correcta del Copy Job y resumen de tablas/filas | `screenshots/data-factory/` |
| `06-bronze-tables.png` | Tablas aterrizadas en Bronze | `screenshots/warehouse/` |
| `07-silver-tables.png` | Tablas Silver y resultado de una validación de recuentos | `screenshots/warehouse/` |
| `08-gold-star-schema.png` | Dimensiones y tabla de hechos Gold | `screenshots/warehouse/` |
| `09-factsales-validation.png` | Recuento de FactSales y validación de claves sin ausencias | `screenshots/warehouse/` |

## Evidencias ya existentes

En `docs/images/gateway/` ya se encuentran estas imágenes:

- `01-gateway-registration.png`
- `02-gateway-online.png`
- `03-sql-login-permissions.png`

La captura del gateway puede reutilizarse como evidencia en la documentación; evita mantener copias redundantes salvo que sea necesario para una presentación.

## Buenas prácticas al capturar

1. Muestra el nombre del elemento y el estado relevante.
2. Incluye el resultado completo de la operación o consulta cuando sea importante.
3. Recorta información personal o identificadores que no aporten valor.
4. Oculta credenciales, contraseñas, tokens, cadenas de conexión y datos sensibles.
5. Utiliza nombres de archivo ordenados y descriptivos.
6. Añade una breve explicación en Markdown cuando una captura no sea autoexplicativa.

## Estado

La lista es una guía de evidencias pendientes de recopilar. No implica que todas las capturas estén ya disponibles en el repositorio.
