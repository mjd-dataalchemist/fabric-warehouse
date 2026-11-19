# Fabric Warehouse — PoC DP-600

Prueba de concepto de Microsoft Fabric orientada a demostrar capacidades relevantes para la certificación **DP-600 (Microsoft Fabric Analytics Engineer)**, desde la ingesta de datos hasta el modelado analítico y su consumo con Power BI.

## Objetivo

Construir una solución analítica sobre datos de ejemplo de **WideWorldImporters**, cuyo origen es una instancia local de SQL Server 2022, utilizando Microsoft Fabric Warehouse. El proyecto sirve como portfolio técnico y laboratorio de aprendizaje; no pretende ser una arquitectura productiva.

## Arquitectura prevista

```text
SQL Server 2022 (WideWorldImporters)
              |
       On-premises Data Gateway
              |
       Fabric Data Factory
          Copy Job
              |
        Warehouse
   Bronze → Silver → Gold
              |
       Modelo semántico
              |
           Power BI
```

La organización Medallion se utiliza como patrón lógico de transformación de datos. No debe confundirse con OneLake ni con un tipo concreto de almacenamiento.

## Tecnologías y conceptos

- Microsoft Fabric Warehouse.
- Data Factory y Copy Job para la ingesta.
- On-premises data gateway para conectar con SQL Server local.
- Arquitectura Medallion: Bronze, Silver y Gold.
- Modelado dimensional Kimball en esquema estrella.
- SQL para transformación y validación.
- Power BI y modelo semántico: siguientes fases del laboratorio.

## Estado actual

| Área | Estado |
|---|---|
| Conectividad con SQL Server mediante gateway | Configurada |
| Ingesta de tablas de origen en Bronze | Completada |
| Transformaciones Silver | Completadas |
| Dimensiones Gold | Creadas y cargadas |
| FactSales | Cargada y validada |
| Validación de claves y relaciones | Completada, sin claves dimensionales ausentes |
| Demostración real de SCD Tipo 2 | Pendiente |
| Modelo semántico y Power BI | Pendiente |
| Seguridad analítica RLS/OLS en Power BI | Pendiente |

### Modelo dimensional implementado

- `gold.FactSales`: granularidad de una fila por línea de pedido (`OrderLineID`).
- `gold.DimDate`
- `gold.DimCustomer`
- `gold.DimProduct`
- `gold.DimSalesperson`

`OrderID` se conserva en la tabla de hechos como dimensión degenerada.

**Nota sobre SCD Tipo 2:** `DimCustomer` dispone de columnas preparadas para versionado (`StartDate`, `EndDate`, `IsCurrent`), pero el proceso de detección de cambios y generación de nuevas versiones todavía no está implementado. Por tanto, no se presenta como una SCD Tipo 2 funcional.

## Estructura del repositorio

```text
fabric-warehouse/
├── docs/
│   ├── architecture/
│   │   └── gateway-setup.md
│   └── images/
│       └── gateway/
├── powerbi/
├── screenshots/
│   ├── architecture/
│   ├── data-factory/
│   ├── power-bi/
│   └── warehouse/
└── sql/
    ├── bronze/
    ├── silver/
    └── gold/
```

- `sql/`: scripts SQL de las capas de transformación y del modelo dimensional.
- `docs/`: documentación del laboratorio y decisiones de arquitectura.
- `screenshots/`: evidencias visuales de la configuración y los resultados.
- `powerbi/`: recursos del modelo semántico e informes cuando se incorporen.

## Consideraciones de la PoC

- La conexión de desarrollo con SQL Server se configuró sin validar la confianza del certificado TLS debido a un problema de certificado local. Es una concesión exclusiva del laboratorio; en producción se debe configurar y validar correctamente el certificado.
- Para completar la extracción de datos de ejemplo se deshabilitó temporalmente una política RLS en el origen. Esta decisión es únicamente para la PoC. En un entorno real se debe mantener una estrategia de acceso autorizada y aplicar la seguridad correspondiente en las capas de consumo y/o almacenamiento.
- La carga inicial de `silver.Products` elimina duplicados idénticos detectados en Bronze. Las cargas repetidas en modo append pueden generar duplicados si no se controla la estrategia de refresco.
- El modelo y las decisiones se simplifican deliberadamente para mantener el foco en las capacidades de Fabric y los objetivos de aprendizaje de DP-600.

## Próximas fases

1. Completar una demostración controlada de SCD Tipo 2.
2. Crear el modelo semántico y las relaciones en Power BI.
3. Explorar el modo Direct Lake cuando sea compatible con el diseño elegido.
4. Configurar y probar RLS/OLS en el contexto del modelo semántico.
5. Añadir capturas, resultados y documentación de las decisiones.
6. Documentar ventajas, limitaciones y diferencias frente a un DWH tradicional on-premises.

## Aviso

Proyecto educativo y demostrativo. No utilizar como solución productiva sin revisar seguridad, gobierno del dato, calidad, supervisión, rendimiento, recuperación y costes de capacidad.
