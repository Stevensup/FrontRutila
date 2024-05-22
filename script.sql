-- Creación de la base de datos
CREATE DATABASE BarUnibosque;
USE BarUnibosque;

CREATE TABLE pubs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    entrytime VARCHAR(10),
    closingtime VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- Tabla de clientes
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- Creación de la tabla de tipos de bebida
CREATE TABLE drink_types(
    id INT AUTO_INCREMENT PRIMARY KEY,
    types VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
    
);

-- Tabla de bebidas
CREATE TABLE drinks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    types INT,
    price DECIMAL(10, 2),
   availability INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (types) REFERENCES drink_types(id)
);




-- Tabla de usuarios
CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
   phone VARCHAR(20),
    id_role INT,
    hash_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- Tabla de pedidos
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_customer INT,
    id_pub INT,
    dates VARCHAR(10),
    id_user INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (id_customer) REFERENCES customers(id),
    FOREIGN KEY (id_pub) REFERENCES pubs(id),
    FOREIGN KEY (id_user) REFERENCES users(id)
);

-- Tabla de detalles de pedidos
CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_order INT,
    id_drink INT,
    amount INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (id_order) REFERENCES orders(id),
    FOREIGN KEY (id_drink) REFERENCES drinks(id)
);


-- Tabla de facturas
CREATE TABLE invoices(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_order INT,
    total DECIMAL(10, 2),
    dates VARCHAR(10) ,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (id_order) REFERENCES orders(id)
);


-- Creación de la tabla de logs
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tables VARCHAR(50) NOT NULL,
    operation VARCHAR(50) NOT NULL,
    users VARCHAR(255),
    detail TEXT,
    dates TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM BarUnibosque.drink_types dt 
select * from BarUnibosque.drinks d 
select * from BarUnibosque.users u 

INSERT INTO BarUnibosque.pubs 
(id, name, location, phone, entrytime, closingtime, created_at, updated_at, deleted_at) 
VALUES
(1, 'The Green Lion', '123 Main Street', '+1234567890', '18:00', '02:00', current_timestamp(), NULL, NULL),
(2, 'The Red Dragon', '456 Oak Avenue', '+0987654321', '19:00', '03:00', current_timestamp(), NULL, NULL),
(3, 'The Blue Unicorn', '789 Elm Boulevard', '+1357924680', '20:00', '04:00', current_timestamp(), NULL, NULL),
(4, 'The Yellow Tiger', '987 Pine Road', '+2468135790', '21:00', '05:00', current_timestamp(), NULL, NULL),
(5, 'The Purple Phoenix', '654 Maple Lane', '+9876543210', '22:00', '06:00', current_timestamp(), NULL, NULL);

-- Creación del trigger para la tabla pubs
CREATE TRIGGER logs_trigger_pubs
AFTER INSERT ON pubs
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('pubs', 'INSERT', NEW.name, CONCAT('New pub inserted: ', NEW.name));
END;

-- Creación del trigger para la tabla drinks
CREATE TRIGGER logs_trigger_drinks
AFTER INSERT ON drinks
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('drinks', 'INSERT', NEW.name, CONCAT('New drink inserted: ', NEW.name));
END;

-- Creación del trigger para la tabla users
CREATE TRIGGER logs_trigger_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('users', 'INSERT', NEW.name, CONCAT('New user inserted: ', NEW.name));
END;

-- Creación del trigger para la tabla drink_types
CREATE TRIGGER logs_trigger_drink_types
AFTER INSERT ON drink_types
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('drink_types', 'INSERT', NEW.types, CONCAT('New drink type inserted: ', NEW.types));
END;

-- Creación del trigger para la tabla invoices
CREATE TRIGGER logs_trigger_invoices
AFTER INSERT ON invoices
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('invoices', 'INSERT', NEW.total, CONCAT('New invoice inserted: ', NEW.total));
END;

-- Creación del trigger para la tabla order_details
CREATE TRIGGER logs_trigger_order_details
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('order_details', 'INSERT', NEW.amount, CONCAT('New order detail inserted: ', NEW.amount));
END;

-- Creación del trigger para la tabla orders
CREATE TRIGGER logs_trigger_orders
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('orders', 'INSERT', NEW.dates, CONCAT('New order inserted: ', NEW.dates));
END;

-- Creación del trigger para la tabla customers
CREATE TRIGGER logs_trigger_customers
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO logs (tables, operation, users, detail)
    VALUES ('customers', 'INSERT', NEW.name, CONCAT('New customer inserted: ', NEW.name));
END;

-- Creación del índice para la tabla pubs
CREATE INDEX idx_pubs_name ON pubs(name);

-- Creación del índice para la tabla drinks
CREATE INDEX idx_drinks_name ON drinks(name);

-- Creación del índice para la tabla users
CREATE INDEX idx_users_name ON users(name);

-- Creación del índice para la tabla drink_types
CREATE INDEX idx_drink_types_types ON drink_types(types);

-- Creación del índice para la tabla invoices
CREATE INDEX idx_invoices_total ON invoices(total);

-- Creación del índice para la tabla order_details
CREATE INDEX idx_order_details_amount ON order_details(amount);

-- Creación del índice para la tabla orders
CREATE INDEX idx_orders_dates ON orders(dates);

-- Creación del índice para la tabla customers
CREATE INDEX idx_customers_name ON customers(name);


