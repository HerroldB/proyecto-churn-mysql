-- Ejecuté este archivo después de importar el CSV limpio en stg_telco.
USE proyecto_churn;

-- Guardé los valores repetidos de contrato y pago una sola vez.
INSERT IGNORE INTO contract_types (contract_name)
SELECT DISTINCT contract_type
FROM stg_telco
WHERE contract_type IS NOT NULL;

INSERT IGNORE INTO payment_methods (method_name)
SELECT DISTINCT payment_method
FROM stg_telco
WHERE payment_method IS NOT NULL;

INSERT IGNORE INTO service_catalog (service_name)
VALUES
    ('phone_service'),
    ('multiple_lines'),
    ('internet_service'),
    ('online_security'),
    ('online_backup'),
    ('device_protection'),
    ('tech_support'),
    ('streaming_tv'),
    ('streaming_movies');

-- Armé la tabla principal con una fila por cliente.
INSERT IGNORE INTO customers (
    customer_id, gender, senior_citizen, partner, dependents, tenure_months,
    contract_type_id, paperless_billing, payment_method_id, churn
)
SELECT
    s.customer_id, s.gender, s.senior_citizen, s.partner, s.dependents,
    s.tenure_months, c.contract_type_id, s.paperless_billing,
    p.payment_method_id, s.churn
FROM stg_telco AS s
JOIN contract_types AS c ON c.contract_name = s.contract_type
JOIN payment_methods AS p ON p.method_name = s.payment_method;

-- Separé los cargos de los datos generales del cliente.
INSERT IGNORE INTO billing_summary (customer_id, monthly_charges, total_charges)
SELECT customer_id, monthly_charges, total_charges
FROM stg_telco;

-- Pasé los servicios a filas para no tener nueve columnas de servicios en customers.
INSERT IGNORE INTO customer_services (customer_id, service_id, service_value)
SELECT s.customer_id, c.service_id, s.phone_service
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'phone_service'
UNION ALL
SELECT s.customer_id, c.service_id, s.multiple_lines
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'multiple_lines'
UNION ALL
SELECT s.customer_id, c.service_id, s.internet_service
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'internet_service'
UNION ALL
SELECT s.customer_id, c.service_id, s.online_security
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'online_security'
UNION ALL
SELECT s.customer_id, c.service_id, s.online_backup
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'online_backup'
UNION ALL
SELECT s.customer_id, c.service_id, s.device_protection
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'device_protection'
UNION ALL
SELECT s.customer_id, c.service_id, s.tech_support
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'tech_support'
UNION ALL
SELECT s.customer_id, c.service_id, s.streaming_tv
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'streaming_tv'
UNION ALL
SELECT s.customer_id, c.service_id, s.streaming_movies
FROM stg_telco AS s JOIN service_catalog AS c ON c.service_name = 'streaming_movies';

-- Usé estas consultas para revisar que se hayan cargado los datos.
SELECT COUNT(*) AS clientes FROM customers;
SELECT COUNT(*) AS cargos FROM billing_summary;
SELECT COUNT(*) AS servicios_cliente FROM customer_services;
