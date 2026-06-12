Use iot_db;

CREATE TABLE IF NOT EXISTS datos_brutos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    node_id VARCHAR(50) NOT NULL,
    temperatura DECIMAL(5,2),
    humedad_aire DECIMAL(5,2),
    humedad_suelo INT,
    timestamp_sensor DATETIME NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lectura_id INT NOT NULL,
    tipo_alerta VARCHAR(50) NOT NULL,
    timestamp_alerta DATETIME NOT NULL,
    
    FOREIGN KEY (lectura_id) REFERENCES datos_brutos(id)
);

CREATE TABLE IF NOT EXISTS activacion_bomba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lectura_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME,
    duracion_segundos INT,
    humedad_final INT,
    motivo_apagado VARCHAR(100),
    
    FOREIGN KEY (lectura_id) REFERENCES datos_brutos(id)
);


CREATE TABLE IF NOT EXISTS incidencias (
    id INT AUTO_INCREMENT PRIMARY KEY,

    lectura_bruta_id INT NOT NULL,
    node_id VARCHAR(50),

    campo_afectado VARCHAR(50),
    tipo_incidencia VARCHAR(100) NOT NULL,

    valor_original VARCHAR(100),
    valor_corregido VARCHAR(100),

    metodo_aplicado VARCHAR(100),
    descripcion TEXT,

    fecha_incidencia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lectura_bruta_id) REFERENCES datos_brutos(id)
);

CREATE TABLE IF NOT EXISTS datos_limpios (
    lectura_bruta_id INT PRIMARY KEY,

    incidencia_id INT NULL,

    node_id VARCHAR(50) NOT NULL,

    temperatura DECIMAL(5,2),
    humedad_aire DECIMAL(5,2),
    humedad_suelo INT,

    timestamp_sensor DATETIME NOT NULL,
    fecha_limpieza TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lectura_bruta_id) REFERENCES datos_brutos(id),
    FOREIGN KEY (incidencia_id) REFERENCES incidencias(id)
);


CREATE TABLE IF NOT EXISTS metricas_estadisticas (
    id INT AUTO_INCREMENT PRIMARY KEY,

    lectura_bruta_id INT NOT NULL,
    node_id VARCHAR(50) NOT NULL,

    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    total_registros INT DEFAULT 0,

    -- =========================
    -- METRICAS DE TEMPERATURA
    -- =========================
    temperatura_media DECIMAL(10,2),
    temperatura_mediana DECIMAL(10,2),
    temperatura_moda DECIMAL(10,2),
    temperatura_minima DECIMAL(10,2),
    temperatura_maxima DECIMAL(10,2),
    temperatura_rango DECIMAL(10,2),
    temperatura_desviacion_estandar DECIMAL(10,4),
    temperatura_varianza DECIMAL(10,4),

    -- =========================
    -- METRICAS DE HUMEDAD DEL AIRE
    -- =========================
    humedad_aire_media DECIMAL(10,2),
    humedad_aire_mediana DECIMAL(10,2),
    humedad_aire_moda DECIMAL(10,2),
    humedad_aire_minima DECIMAL(10,2),
    humedad_aire_maxima DECIMAL(10,2),
    humedad_aire_rango DECIMAL(10,2),
    humedad_aire_desviacion_estandar DECIMAL(10,4),
    humedad_aire_varianza DECIMAL(10,4),

    -- =========================
    -- METRICAS DE HUMEDAD DEL SUELO
    -- =========================
    humedad_suelo_media DECIMAL(10,2),
    humedad_suelo_mediana DECIMAL(10,2),
    humedad_suelo_moda DECIMAL(10,2),
    humedad_suelo_minima DECIMAL(10,2),
    humedad_suelo_maxima DECIMAL(10,2),
    humedad_suelo_rango DECIMAL(10,2),
    humedad_suelo_desviacion_estandar DECIMAL(10,4),
    humedad_suelo_varianza DECIMAL(10,4),

    -- =========================
    -- CONTEOS DE CALIDAD DEL DATO
    -- =========================
    cantidad_incidencias INT DEFAULT 0,
    cantidad_duplicados INT DEFAULT 0,
    cantidad_imputados INT DEFAULT 0,
    cantidad_anomalias INT DEFAULT 0,

    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lectura_bruta_id) REFERENCES datos_brutos(id)
);


