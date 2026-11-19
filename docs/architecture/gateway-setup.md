# Configuración del On-premises Data Gateway

## 1. Objetivo

Configurar una puerta de enlace local que permita a Microsoft Fabric conectarse con SQL Server 2022 instalado en nuestro equipo Windows.

Esta conexión será utilizada por Fabric Data Factory para extraer datos de `WideWorldImporters`.

## 2. Modalidad seleccionada

**On-premises data gateway — Standard Mode**

Se utiliza Standard Mode porque permite conectar servicios de Microsoft Fabric y compartir conexiones mediante una puerta de enlace administrada.

## 3. Registro de la puerta de enlace

- Nombre: `GW_DP600_DEV`
- Modalidad: Standard
- Región: Spain Central
- Estado: En línea
- Microsoft Fabric: Listo
- Versión observada: 3000.342.5 (November 2026)

La clave de recuperación debe almacenarse de forma segura y nunca incluirse en GitHub.

## 4. Evidencias

### 4.1. Selección de registro

Captura: `images/gateway/01-gateway-registration.png`

### 4.2. Puerta de enlace registrada y operativa

![Gateway online](images/gateway/02-gateway-online.png)

La aplicación confirma que `GW_DP600_DEV` está en línea y preparada para utilizarse. Microsoft Fabric aparece con estado «Listo».

## 5. Estado de configuración

- [x] Instalación del Gateway Standard.
- [x] Registro de una nueva puerta de enlace.
- [x] Nombre y región configurados.
- [x] Estado en línea verificado.
- [x] Servicio Microsoft Fabric disponible.
- [ ] Conexión SQL Server creada en Fabric.
- [ ] Conectividad comprobada desde Data Factory.

## 6. Arquitectura

SQL Server 2022 (local) → On-premises Data Gateway → Fabric Data Factory → WH_DP600.

## 7. Usuario técnico de SQL Server

Se ha creado un usuario específico para la ingesta de datos desde Microsoft Fabric.

**Identidad:** `fabric_ingest`

**Base de datos:** `WideWorldImporters`

**Permisos asignados:**
- Rol `db_datareader`.
- Lectura de tablas y vistas.
- Sin permisos de escritura concedidos.

### Validación de permisos

Se ha ejecutado una prueba mediante `EXECUTE AS LOGIN`.

| Comprobación | Resultado |
|---|---:|
| DatabaseUser | fabric_ingest |
| IsDataReader | 1 |
| CanReadOrders | 1 |
| CanInsertOrders | 0 |

**Resultado:** validación satisfactoria.

Se aplica el principio de mínimo privilegio: la cuenta de ingesta puede leer los datos necesarios sin disponer de permisos de modificación.

## Adaptación del origen SQL Server para Fabric

### Problema detectado

Durante la ingesta mediante Copy Job se detectó que el tipo `geography` de SQL Server no era compatible con la copia directa.

### Solución implementada

Se creó el esquema `fabric_export` en `WideWorldImporters`, con cuatro vistas SQL que convierten los valores espaciales a WKT mediante `STAsText()` y conservan su SRID mediante `STSrid`.

### Vistas creadas

| Vista | Tabla de origen | Filas |
|---|---|---:|
| vw_Cities | Application.Cities | 37.940 |
| vw_Countries | Application.Countries | 190 |
| vw_StateProvinces | Application.StateProvinces | 53 |
| vw_Customers | Sales.Customers | 663 |

### Validación

Las cuatro vistas se consultaron correctamente desde SSMS y devolvieron los registros esperados.

**Decisión de arquitectura:** mantener intactas las tablas OLTP originales y utilizar una capa de exposición específica para la ingesta hacia Microsoft Fabric.