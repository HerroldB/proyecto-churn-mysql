-- Primero creé la base y las tablas que voy a usar en MySQL Workbench.
CREATE DATABASE IF NOT EXISTS proyecto_churn;
USE proyecto_churn;

-- Esta tabla es temporal: acá importé el CSV limpio desde Workbench.
CREATE TABLE IF NOT EXISTS stg_telco (
    customer_id VARCHAR(20) NOT NULL,
    gender VARCHAR(15),
    senior_citizen TINYINT,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure_months SMALLINT,
    phone_service VARCHAR(30),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    contract_type VARCHAR(30),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(50),
    monthly_charges DECIMAL(10,2),
    total_charges DECIMAL(10,2),
    churn VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS contract_types (
    contract_type_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    contract_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS payment_methods (
    payment_method_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(15),
    senior_citizen TINYINT,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure_months SMALLINT,
    contract_type_id TINYINT NOT NULL,
    paperless_billing VARCHAR(5),
    payment_method_id TINYINT NOT NULL,
    churn VARCHAR(5),
    FOREIGN KEY (contract_type_id) REFERENCES contract_types(contract_type_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
);

CREATE TABLE IF NOT EXISTS billing_summary (
    customer_id VARCHAR(20) PRIMARY KEY,
    monthly_charges DECIMAL(10,2),
    total_charges DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS service_catalog (
    service_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS customer_services (
    customer_id VARCHAR(20) NOT NULL,
    service_id TINYINT NOT NULL,
    service_value VARCHAR(30),
    PRIMARY KEY (customer_id, service_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (service_id) REFERENCES service_catalog(service_id)
);
