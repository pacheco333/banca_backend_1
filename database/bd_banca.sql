
CREATE DATABASE banca_uno;
USE banca_uno;

CREATE TABLE clientes (
   id_cliente INT NOT NULL AUTO_INCREMENT,
   numero_documento VARCHAR(20) NOT NULL,
   tipo_documento ENUM('CC','TI','R.Civil','PPT','Pasaporte','CarneDiplomatico','CedulaExtranjeria') NOT NULL,
   lugar_expedicion VARCHAR(100) DEFAULT NULL,
   ciudad_nacimiento VARCHAR(100) DEFAULT NULL,
   fecha_nacimiento DATE DEFAULT NULL,
   fecha_expedicion DATE DEFAULT NULL,
   primer_nombre VARCHAR(50) NOT NULL,
   segundo_nombre VARCHAR(50) DEFAULT NULL,
   primer_apellido VARCHAR(50) NOT NULL,
   segundo_apellido VARCHAR(50) DEFAULT NULL,
   genero ENUM('M','F') NOT NULL,
   nacionalidad ENUM('Colombiano','Estadounidense','Otra') NOT NULL,
   otra_nacionalidad VARCHAR(100) DEFAULT NULL,
   estado_civil ENUM('Soltero','Casado','Unión Libre','Divorciado','Viudo') NOT NULL,
   grupo_etnico ENUM('Indígena','Gitano','Raizal','Palenquero','Afrocolombiano','Ninguna') NOT NULL,
   fecha_registro TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id_cliente),
   UNIQUE KEY numero_documento (numero_documento),
   KEY idx_documento (tipo_documento, numero_documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE actividad_economica (
   id_actividad_economica INT NOT NULL AUTO_INCREMENT,
   profesion VARCHAR(100) DEFAULT NULL,
   ocupacion VARCHAR(100) DEFAULT NULL,
   codigo_CIIU VARCHAR(20) DEFAULT NULL,
   detalle_actividad TEXT,
   numero_empleados INT DEFAULT NULL,
   facta_crs ENUM('Sí','No') DEFAULT 'No',
   id_cliente INT DEFAULT NULL,
   PRIMARY KEY (id_actividad_economica),
   UNIQUE KEY id_cliente (id_cliente),
   KEY idx_cliente (id_cliente),
   CONSTRAINT actividad_economica_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE contacto_personal (
   id_contacto INT NOT NULL AUTO_INCREMENT,
   direccion VARCHAR(255) DEFAULT NULL,
   barrio VARCHAR(100) DEFAULT NULL,
   departamento VARCHAR(100) DEFAULT NULL,
   telefono VARCHAR(20) DEFAULT NULL,
   ciudad VARCHAR(100) DEFAULT NULL,
   pais VARCHAR(100) DEFAULT NULL,
   correo VARCHAR(100) DEFAULT NULL,
   bloque_torre VARCHAR(50) DEFAULT NULL,
   apto_casa VARCHAR(50) DEFAULT NULL,
   id_cliente INT DEFAULT NULL,
   PRIMARY KEY (id_contacto),
   UNIQUE KEY id_cliente (id_cliente),
   CONSTRAINT contacto_personal_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE info_financiera (
   id_info_financiera INT NOT NULL AUTO_INCREMENT,
   ingresos_mensuales DECIMAL(15,2) DEFAULT NULL,
   egresos_mensuales DECIMAL(15,2) DEFAULT NULL,
   total_activos DECIMAL(15,2) DEFAULT NULL,
   total_pasivos DECIMAL(15,2) DEFAULT NULL,
   id_cliente INT DEFAULT NULL,
   PRIMARY KEY (id_info_financiera),
   UNIQUE KEY id_cliente (id_cliente),
   CONSTRAINT info_financiera_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE info_laboral (
   id_info_laboral INT NOT NULL AUTO_INCREMENT,
   nombre_empresa VARCHAR(100) NOT NULL,
   direccion_empresa VARCHAR(150) DEFAULT NULL,
   pais_empresa VARCHAR(100) DEFAULT NULL,
   departamento_empresa VARCHAR(100) DEFAULT NULL,
   ciudad_empresa VARCHAR(100) DEFAULT NULL,
   telefono_empresa VARCHAR(20) DEFAULT NULL,
   ext VARCHAR(10) DEFAULT NULL,
   celular_empresa VARCHAR(20) DEFAULT NULL,
   correo_laboral VARCHAR(100) DEFAULT NULL,
   id_cliente INT DEFAULT NULL,
   PRIMARY KEY (id_info_laboral),
   UNIQUE KEY id_cliente (id_cliente),
   CONSTRAINT info_laboral_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Facta_Crs (
   id_facta_crs INT NOT NULL AUTO_INCREMENT,
   id_cliente INT NOT NULL,
   es_residente_extranjero ENUM('Sí','No') NOT NULL DEFAULT 'No',
   pais VARCHAR(100) DEFAULT NULL,
   PRIMARY KEY (id_facta_crs),
   KEY id_cliente (id_cliente),
   CONSTRAINT Facta_Crs_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuarios (
   id_usuario INT NOT NULL AUTO_INCREMENT,
   nombre VARCHAR(100) NOT NULL,
   correo VARCHAR(120) NOT NULL,
   contrasena VARCHAR(255) NOT NULL,
   fecha_creacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   activo TINYINT(1) NOT NULL DEFAULT 1,
   PRIMARY KEY (id_usuario),
   UNIQUE KEY correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE roles (
   id_rol INT NOT NULL AUTO_INCREMENT,
   nombre VARCHAR(80) NOT NULL,
   descripcion VARCHAR(255) DEFAULT NULL,
   PRIMARY KEY (id_rol),
   UNIQUE KEY nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuario_rol (
   id_usuario_rol INT NOT NULL AUTO_INCREMENT,
   id_usuario INT NOT NULL,
   id_rol INT NOT NULL,
   asignado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id_usuario_rol),
   UNIQUE KEY unique_usuario_rol (id_usuario, id_rol),
   KEY idx_usuario (id_usuario),
   KEY idx_rol (id_rol),
   CONSTRAINT usuario_rol_ibfk_1 FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
   CONSTRAINT usuario_rol_ibfk_2 FOREIGN KEY (id_rol) REFERENCES roles (id_rol) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE boveda (
   id_boveda INT NOT NULL AUTO_INCREMENT,
   saldo_efectivo DECIMAL(15,2) DEFAULT 0.00,
   saldo_cheques DECIMAL(15,2) DEFAULT 0.00,
   fecha_actualizacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   ultima_actualizacion_por INT DEFAULT NULL,
   PRIMARY KEY (id_boveda),
   KEY ultima_actualizacion_por (ultima_actualizacion_por),
   CONSTRAINT boveda_ibfk_1 FOREIGN KEY (ultima_actualizacion_por) REFERENCES usuarios (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE oficina (
   id_oficina INT NOT NULL AUTO_INCREMENT,
   saldo_efectivo DECIMAL(15,2) DEFAULT 0.00,
   saldo_cheques DECIMAL(15,2) DEFAULT 0.00,
   fecha_actualizacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   ultima_actualizacion_por INT DEFAULT NULL,
   PRIMARY KEY (id_oficina),
   KEY ultima_actualizacion_por (ultima_actualizacion_por),
   CONSTRAINT oficina_ibfk_1 FOREIGN KEY (ultima_actualizacion_por) REFERENCES usuarios (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cajas (
   id_caja INT NOT NULL AUTO_INCREMENT,
   nombre_caja VARCHAR(50) NOT NULL,
   estado ENUM('LIBRE','OCUPADA') NOT NULL DEFAULT 'LIBRE',
   usuario_asignado INT DEFAULT NULL,
   fecha_asignacion DATETIME DEFAULT NULL,
   PRIMARY KEY (id_caja),
   KEY idx_estado (estado),
   KEY idx_usuario_asignado (usuario_asignado),
   CONSTRAINT fk_cajas_usuario FOREIGN KEY (usuario_asignado) REFERENCES usuarios (id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE saldos_cajero (
   id_saldo INT NOT NULL AUTO_INCREMENT,
   id_usuario INT DEFAULT NULL COMMENT 'Referencia al usuario (cajero)',
   cajero VARCHAR(50) NOT NULL COMMENT 'Nombre del cajero',
   saldo_efectivo DECIMAL(15,2) DEFAULT 0.00,
   saldo_cheques DECIMAL(15,2) DEFAULT 0.00,
   id_caja INT DEFAULT NULL COMMENT 'Caja asignada al cajero',
   fecha_creacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   fecha_actualizacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (id_saldo),
   UNIQUE KEY cajero (cajero),
   KEY idx_cajero (cajero),
   KEY idx_fecha (fecha_actualizacion),
   KEY idx_usuario (id_usuario),
   KEY idx_caja (id_caja),
   CONSTRAINT saldos_cajero_ibfk_1 FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
   CONSTRAINT saldos_cajero_ibfk_2 FOREIGN KEY (id_caja) REFERENCES cajas (id_caja) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE solicitudes_apertura (
   id_solicitud INT NOT NULL AUTO_INCREMENT,
   id_cliente INT NOT NULL,
   id_usuario_rol INT DEFAULT NULL COMMENT 'Asesor que creó la solicitud (opcional)',
   tipo_cuenta ENUM('Ahorros') NOT NULL DEFAULT 'Ahorros',
   estado ENUM('Pendiente','Aprobada','Rechazada','Devuelta','Aperturada') NOT NULL DEFAULT 'Pendiente',
   comentario_director TEXT,
   comentario_asesor TEXT,
   archivo LONGBLOB,
   fecha_solicitud TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   fecha_respuesta TIMESTAMP NULL DEFAULT NULL,
   PRIMARY KEY (id_solicitud),
   KEY idx_sol_estado (estado),
   KEY idx_sol_cliente (id_cliente),
   KEY idx_sol_usuario_rol (id_usuario_rol),
   CONSTRAINT fk_sol_usuario_rol FOREIGN KEY (id_usuario_rol) REFERENCES usuario_rol (id_usuario_rol) ON DELETE SET NULL,
   CONSTRAINT solicitudes_apertura_ibfk_1 FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
   CONSTRAINT solicitudes_apertura_ibfk_2 FOREIGN KEY (id_usuario_rol) REFERENCES usuario_rol (id_usuario_rol) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cuentas_ahorro (
   id_cuenta INT NOT NULL AUTO_INCREMENT,
   numero_cuenta VARCHAR(20) NOT NULL,
   id_cliente INT NOT NULL,
   id_solicitud INT DEFAULT NULL,
   saldo DECIMAL(15,2) NOT NULL DEFAULT 0.00,
   estado_cuenta ENUM('Activa','Inactiva','Bloqueada','Cerrada') NOT NULL DEFAULT 'Activa',
   fecha_apertura TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id_cuenta),
   UNIQUE KEY numero_cuenta (numero_cuenta),
   KEY idx_cta_numero (numero_cuenta),
   KEY idx_cta_cliente (id_cliente),
   KEY idx_cta_solicitud (id_solicitud),
   KEY idx_estado (estado_cuenta),
   CONSTRAINT fk_cta_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
   CONSTRAINT fk_cta_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitudes_apertura (id_solicitud)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE gestion_cuentas (
   id_gestion_cuentas INT NOT NULL AUTO_INCREMENT,
   id_usuario INT NOT NULL,
   id_cuenta INT NOT NULL,
   activo TINYINT(1) NOT NULL DEFAULT 1,
   asignado_en TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id_gestion_cuentas),
   KEY id_usuario (id_usuario),
   KEY id_cuenta (id_cuenta),
   CONSTRAINT gestion_cuentas_ibfk_1 FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
   CONSTRAINT gestion_cuentas_ibfk_2 FOREIGN KEY (id_cuenta) REFERENCES cuentas_ahorro (id_cuenta) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE transacciones (
   id_transaccion INT NOT NULL AUTO_INCREMENT,
   id_cuenta INT NOT NULL,
   tipo_transaccion ENUM('Apertura','Depósito','Retiro','Nota Débito','Cancelación','Transferencia','Pago','Otro') NOT NULL,
   tipo_deposito ENUM('Efectivo','Cheque','Transferencia','Otro') DEFAULT NULL,
   monto DECIMAL(15,2) NOT NULL,
   codigo_cheque VARCHAR(50) DEFAULT NULL,
   numero_cheque VARCHAR(50) DEFAULT NULL,
   saldo_anterior DECIMAL(15,2) DEFAULT NULL,
   saldo_nuevo DECIMAL(15,2) DEFAULT NULL,
   id_usuario INT DEFAULT NULL COMMENT 'Usuario (cajero) que realizó la transacción',
   id_caja INT DEFAULT NULL COMMENT 'Caja en la que se realizó la transacción',
   fecha_transaccion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   cajero VARCHAR(50) DEFAULT NULL COMMENT 'Cajero que realizó la transacción',
   motivo_cancelacion VARCHAR(500) DEFAULT NULL COMMENT 'Motivo de cancelación de cuenta',
   PRIMARY KEY (id_transaccion),
   KEY idx_cuenta_trans (id_cuenta),
   KEY idx_tipo_trans (tipo_transaccion),
   KEY idx_fecha (fecha_transaccion),
   KEY idx_cajero (cajero),
   KEY id_caja (id_caja),
   KEY idx_usuario (id_usuario),
   CONSTRAINT transacciones_ibfk_1 FOREIGN KEY (id_cuenta) REFERENCES cuentas_ahorro (id_cuenta) ON DELETE CASCADE,
   CONSTRAINT transacciones_ibfk_2 FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
   CONSTRAINT transacciones_ibfk_3 FOREIGN KEY (id_caja) REFERENCES cajas (id_caja) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE traslados_cajero (
   id_traslado INT NOT NULL AUTO_INCREMENT,
   id_usuario_origen INT DEFAULT NULL COMMENT 'Cajero que envía',
   id_usuario_destino INT DEFAULT NULL COMMENT 'Cajero que recibe',
   cajero_origen VARCHAR(50) NOT NULL,
   cajero_destino VARCHAR(50) NOT NULL,
   monto DECIMAL(15,2) NOT NULL,
   estado ENUM('Pendiente','Aceptado') DEFAULT 'Pendiente',
   fecha_envio TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   fecha_aceptacion TIMESTAMP NULL DEFAULT NULL,
   PRIMARY KEY (id_traslado),
   KEY idx_estado (estado),
   KEY idx_destino_estado (id_usuario_destino, estado),
   KEY idx_origen (id_usuario_origen),
   CONSTRAINT traslados_cajero_ibfk_1 FOREIGN KEY (id_usuario_origen) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
   CONSTRAINT traslados_cajero_ibfk_2 FOREIGN KEY (id_usuario_destino) REFERENCES usuarios (id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
