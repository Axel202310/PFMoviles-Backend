DROP DATABASE IF EXISTS finanzasBD;
CREATE DATABASE finanzasBD CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE finanzasBD;

-- 1. Tabla de Usuarios: Sin cambios. Estructura sólida.
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo_usuario VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Cuentas: Sin cambios. Perfecta para el flujo de la app.
CREATE TABLE cuentas (
    id_cuenta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre_cuenta VARCHAR(50) NOT NULL,
    saldo_actual DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    moneda VARCHAR(5) NOT NULL DEFAULT 'PEN',
    img_cuenta VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Tabla de Categorías: AJUSTE CLAVE para categorías por defecto.
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    -- Permitimos NULL en id_usuario. Si es NULL, es una categoría por defecto del sistema.
    -- Si tiene un valor, es una categoría personalizada de ese usuario.
    id_usuario INT NULL, 
    nombre_categoria VARCHAR(50) NOT NULL,
    tipo_categoria ENUM('ingreso', 'gasto') NOT NULL,
    img_categoria VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Tabla de Transacciones: AJUSTE CRÍTICO para eliminar redundancia.
CREATE TABLE transacciones (
    id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_cuenta INT NOT NULL,
    id_categoria INT NOT NULL,
    monto_transaccion DECIMAL(10, 2) NOT NULL,
    -- Se elimina la columna 'tipo_transaccion'.
    -- El tipo se obtiene siempre de la categoría asociada (JOIN con la tabla categorias).
    -- Esto garantiza la integridad de los datos y simplifica la lógica de inserción.
    descripcion VARCHAR(255),
    fecha_transaccion DATETIME NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cuenta) REFERENCES cuentas(id_cuenta) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla de Historial de Transferencias
CREATE TABLE historial_transferencias (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_cuenta_origen INT NOT NULL,
    id_cuenta_destino INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    comentario VARCHAR(255) NULL,
    fecha_transferencia_realizada DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_cuenta_origen) REFERENCES cuentas(id_cuenta) ON DELETE CASCADE,
    FOREIGN KEY (id_cuenta_destino) REFERENCES cuentas(id_cuenta) ON DELETE CASCADE
);

-- 7. Índices: Optimizados para las consultas más frecuentes de la app.
CREATE INDEX idx_cuentas_usuario ON cuentas(id_usuario);
CREATE INDEX idx_transacciones_cuenta ON transacciones(id_cuenta);
CREATE INDEX idx_transacciones_categoria ON transacciones(id_categoria);
-- NUEVO ÍNDICE: Para acelerar la búsqueda de categorías de un usuario específico y las por defecto.
CREATE INDEX idx_categorias_usuario ON categorias(id_usuario);


-- 8. Datos Iniciales: Insertar las categorías por defecto del sistema.
INSERT INTO categorias (id_usuario, nombre_categoria, tipo_categoria, img_categoria) VALUES
(NULL, 'Educación', 'gasto', 'ic_categoria_educacion'),
(NULL, 'Salud', 'gasto', 'ic_categoria_salud'),
(NULL, 'Transporte', 'gasto', 'ic_categoria_transporte'),
(NULL, 'Hogar', 'gasto', 'ic_categoria_hogar'),
(NULL, 'Alimentos', 'gasto', 'ic_categoria_alimentos'),
(NULL, 'Regalos', 'gasto', 'ic_categoria_regalos'),
(NULL, 'Otros', 'gasto', 'ic_categoria_otros_gastos'),
(NULL, 'Salario', 'ingreso', 'ic_categoria_salario'),
(NULL, 'Regalo', 'ingreso', 'ic_categoria_regalo_recibido'),
(NULL, 'Intereses', 'ingreso', 'ic_categoria_intereses'),
(NULL, 'Otros', 'ingreso', 'ic_categoria_otros_ingresos');


select * from usuarios;
select * from cuentas;
select * from transacciones;
select * from categorias;
select * from historial_transferencias;
