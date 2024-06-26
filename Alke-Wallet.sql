CREATE SCHEMA IF NOT EXISTS `Alke_Wallet` DEFAULT CHARACTER SET utf8mb4;
USE Alke_Wallet;

CREATE TABLE IF NOT EXISTS usuario(
user_id INT primary key auto_increment,
nombre VARCHAR(50) NOT NULL,
correo_electronico VARCHAR(100) NOT NULL UNIQUE,
contrasegna VARCHAR(8) NOT NULL,
saldo DECIMAL(10,2) NOT NULL,
fecha_creacion TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transaccion(
transaction_id INT primary key auto_increment,
sender_user_id INT,
receiver_user_id INT,
moneda_id INT,
importe DECIMAL(10,2) NOT NULL,
CONSTRAINT sender_user FOREIGN KEY(sender_user_id) REFERENCES usuario(user_id) ON DELETE SET NULL,
CONSTRAINT receiver_user FOREIGN KEY (receiver_user_id) REFERENCES usuario(user_id) ON DELETE SET NULL,
CONSTRAINT moneda FOREIGN KEY (moneda_id) REFERENCES moneda(currency_id) ON DELETE SET NULL,
transaction_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS moneda(
currency_id INT primary key auto_increment,
currency_name VARCHAR(50) NOT NULL UNIQUE,
currency_symbol CHAR(3),
creationDate timestamp
);

INSERT INTO moneda (currency_name, currency_symbol, creationDate) 
VALUES ('Rublo', '₽', CURRENT_TIMESTAMP),
('Won', '₩', CURRENT_TIMESTAMP),
('Yen japonés', '¥', CURRENT_TIMESTAMP),
('Euro', '€', CURRENT_TIMESTAMP),
('Dólar canadiense', 'C$', CURRENT_TIMESTAMP),
('Dólar estadounidense', 'US$', CURRENT_TIMESTAMP);

INSERT INTO usuario (nombre, correo_electronico,contrasegna,saldo,fecha_creacion) 
VALUES ('Clarivel','clariv@hotmail.com','12345678', 100.000, CURRENT_TIMESTAMP),
('Luis','LuisA@hotmail.com','12345678', 250.000, CURRENT_TIMESTAMP),
('Dante','DanteP@hotmail.com','12345678', 500.000, CURRENT_TIMESTAMP),
('Francisco','Francis@hotmail.com','12345678', 500.000, CURRENT_TIMESTAMP),
('Juancito','juanci@hotmail.com','12345678', 250.000, CURRENT_TIMESTAMP);

INSERT INTO transaccion(sender_user_id, receiver_user_id, moneda_id, importe, transaction_date) 
VALUES (1,2,3,500.000,CURRENT_TIMESTAMP), 
(1,4,1,600.000,CURRENT_TIMESTAMP),
(2,4,2,650.000,CURRENT_TIMESTAMP),
(4,1,2,250.000,CURRENT_TIMESTAMP),
(5,2,5,450.000,CURRENT_TIMESTAMP);


-- Consulta para obtener el nombre de la moneda elegida por un usuario específico
SELECT nombre, currency_name FROM transaccion 
INNER JOIN moneda ON transaccion.moneda_id = moneda.currency_id
INNER JOIN usuario ON  transaccion.sender_user_id =  usuario.user_id
WHERE sender_user_id = 2;

SELECT nombre,currency_name FROM usuario
INNER JOIN transaccion ON  usuario.user_id = transaccion.sender_user_id
INNER JOIN moneda ON moneda.currency_id =  transaccion.moneda_id 
WHERE user_id = 1;

SELECT nombre, currency_name FROM moneda
INNER JOIN transaccion ON  moneda.currency_id = transaccion.moneda_id
INNER JOIN usuario ON  transaccion.sender_user_id =  usuario.user_id
WHERE user_id = 4;

-- Consulta para obtener todas las transacciones registradas
SELECT transaction_id, sender.nombre AS sender_user, receiver.nombre AS receiver_user,moneda.currency_name,moneda.currency_symbol, importe, transaction_date
FROM transaccion
INNER JOIN usuario AS sender ON  transaccion.sender_user_id= sender.user_id 
INNER JOIN usuario AS receiver ON  transaccion.receiver_user_id = receiver.user_id 
INNER JOIN moneda ON transaccion.moneda_id = moneda.currency_id
ORDER BY transaction_id ASC;

-- Consulta para obtener todas las transacciones realizadas por un usuario específico
SELECT transaction_id, sender.nombre AS sender_user, receiver.nombre AS receiver_user,currency_symbol, importe, transaction_date
FROM transaccion
INNER JOIN usuario AS sender ON  transaccion.sender_user_id= sender.user_id 
INNER JOIN usuario AS receiver ON  transaccion.receiver_user_id = receiver.user_id 
INNER JOIN moneda ON transaccion.moneda_id = moneda.currency_id
WHERE sender_user_id = 1
ORDER BY transaction_id ASC;


-- Sentencia DML para modificar el campo correo electrónico de un usuario específico
UPDATE usuario SET correo_electronico = 'vamosClari@hotmail.com'
WHERE user_id = 1;

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM transaccion
WHERE transaction_id = 2;

SELECT * FROM transaccion;
SELECT * FROM moneda;
SELECT * FROM usuario;
