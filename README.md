# Proyecto de churn — Entregable 1

En este repo dejé la revisión y limpieza básica del CSV, más los scripts y el diagrama para armar la base normalizada en MySQL Workbench.

## Archivos

- `notebooks/01_exploracion_limpieza.ipynb`: descargué, revisé y limpié el CSV con Python.
- `data_and_sql/01_crear_tablas.sql`: preparé la base y las tablas en MySQL.
- `data_and_sql/02_normalizar_datos.sql`: preparé el paso de los datos a las tablas normalizadas.
- `data_and_sql/diagrama_entidad_relacion.svg`: dibujé las relaciones entre las tablas.
- `requirements.txt`: anoté las librerías usadas.

## Cómo lo revisé

Primero cargué el archivo de la cátedra en Python. Después usé `shape`, `info()`, `head()` e `isnull().sum()` para mirar el tamaño, las columnas, algunas filas y los valores faltantes.

El CSV tiene 7.043 filas y 21 columnas. Encontré 11 celdas vacías en `TotalCharges`; las completé con 0 porque esas filas tienen `tenure` igual a 0. Revisé duplicados por `customerID`, números negativos y valores alejados con el rango intercuartílico de `MonthlyCharges`. En esta prueba no encontré filas que quitar por esos motivos.

El notebook guarda el archivo limpio como `Telco_Customer_Churn_limpio.csv`. La fuente es el enlace que aparece en el script de PP2 de la cátedra: [Telco Customer Churn](https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv).

## Cómo pasar los datos a MySQL Workbench

1. Abrí y ejecutá `data_and_sql/01_crear_tablas.sql`.
2. Importá `Telco_Customer_Churn_limpio.csv` en la tabla `stg_telco` con **Table Data Import Wizard**.
3. Abrí y ejecutá `data_and_sql/02_normalizar_datos.sql`.
4. Mirá los conteos que aparecen al final del segundo archivo.

Las tablas principales quedaron separadas así: `customers` guarda los datos de cada cliente; `billing_summary`, sus cargos; `contract_types` y `payment_methods`, los valores repetidos; y `service_catalog` con `customer_services`, los servicios que tiene cada cliente. `stg_telco` conserva la copia de trabajo del CSV.

Probé el notebook con el CSV y terminó con 7.043 filas, 21 columnas y sin vacíos en `total_charges`. Dejé los scripts SQL y el diagrama listos para Workbench; no pude ejecutar Workbench desde este entorno.
