# 🏵️🪴Smart Irrigation IoT System 🪴🏵️
## Descripción del proyecto

Smart Irrigation IoT System es un proyecto académico desarrollado para la materia de IoT — Internet de las Cosas. El proyecto consiste en un sistema de riego inteligente capaz de recolectar, procesar, almacenar y visualizar datos relacionados con el estado de una planta, con el objetivo de automatizar el proceso de riego y mejorar el cuidado de la misma.

El sistema utiliza un nodo hardware basado en ESP32, sensores físicos para capturar variables ambientales y del suelo, comunicación mediante el protocolo MQTT, procesamiento de datos en Node-RED, almacenamiento en una base de datos MySQL y servicios desplegados mediante Docker.

Además del nodo físico, el proyecto incluye un simulador de datos con una representación visual de una materita virtual, lo que permite probar el funcionamiento del sistema sin depender exclusivamente del hardware real.

## Situación problema

Actualmente, muchas personas tienen una rutina diaria muy ocupada, lo que dificulta dedicar el tiempo y la atención necesarios al cuidado adecuado de sus plantas. Además, en muchos casos no se sabe con certeza cuál es el momento ideal para regarlas, ya que factores como la apariencia de la tierra, la exposición al sol o la temperatura ambiente no siempre son suficientes para determinar si la planta realmente necesita agua.

Esta falta de precisión puede provocar tanto exceso como escasez de riego, afectando negativamente el crecimiento, la salud e incluso la supervivencia de las plantas.

Frente a esta problemática, surge como solución un sistema de riego inteligente basado en IoT, capaz de monitorear variables relevantes en tiempo real y tomar decisiones automáticas a partir de los datos recolectados.

Un sistema de riego inteligente permite controlar y automatizar el riego mediante sensores, actuadores y conectividad a través de Internet. Estos sistemas pueden ajustar el riego en función de variables como la humedad del suelo, la temperatura ambiental y las necesidades de la planta, evitando el desperdicio de agua y favoreciendo su cuidado.

## Objetivo general

Diseñar e implementar un sistema IoT de riego inteligente que permita monitorear variables ambientales y del suelo, procesar los datos recolectados, generar alertas, calcular métricas estadísticas, realizar imputación de datos y controlar automáticamente una bomba de agua mediante un flujo de procesamiento en Node-RED.


## Tecnologías utilizadas
### PlatformIO

**PlatformIO** es una plataforma de desarrollo utilizada para programar sistemas embebidos y dispositivos IoT. Permite trabajar con diferentes placas de desarrollo, frameworks y librerías desde un entorno organizado y profesional.

En este proyecto, PlatformIO se utiliza para desarrollar y cargar el código del ESP32, encargado de leer los sensores, conectarse a Internet, publicar datos en el broker MQTT y recibir comandos para controlar la bomba de agua.

### ESP32

El **ESP32** es el microcontrolador principal del nodo hardware. Este dispositivo permite conectividad Wi-Fi, lectura de sensores y control de actuadores.

En el proyecto, el ESP32 cumple las siguientes funciones:

- Captura datos del sensor DHT11.
- Captura datos del sensor HW-390.
- Procesa condiciones básicas de riego.
- Se conecta a Internet mediante Wi-Fi.
- Publica datos en el tópico MQTT correspondiente.
- Recibe comandos desde Node-RED para encender o apagar la bomba.
- Docker

**Docker** es una plataforma que permite ejecutar aplicaciones dentro de contenedores. Un contenedor incluye todo lo necesario para que un servicio funcione de forma aislada, portable y fácil de desplegar.

En este proyecto, Docker se utiliza para ejecutar servicios como:

- Node-RED
- MySQL

Esto facilita la instalación y ejecución del sistema, evitando configurar manualmente cada servicio en el sistema operativo.

### Node-RED

**Node-RED** es una herramienta de desarrollo visual basada en flujos, ampliamente utilizada en proyectos IoT. Permite conectar dispositivos, APIs, bases de datos y servicios mediante nodos gráficos.

***En este proyecto, Node-RED se encarga de:***

- Recibir datos desde el broker MQTT.
- Procesar las lecturas del ESP32 y del simulador.
- Validar datos de entrada.
- Generar estados y alertas.
- Enviar comandos de control hacia la bomba.
- Insertar datos en la base de datos MySQL.
- Calcular métricas estadísticas.
- Aplicar procesos de limpieza e imputación.
- Alimentar el dashboard informativo.
- MySQL

***MySQL es un sistema de gestión de bases de datos relacional. Permite almacenar información de forma estructurada mediante tablas, relaciones y consultas SQL.***

En este proyecto, MySQL se utiliza para guardar:

- Datos brutos capturados por los sensores.
- Alertas generadas por el sistema.
- Registros de activación de la bomba.
- Incidencias en los datos.
- Datos limpios después del procesamiento.
- Métricas estadísticas calculadas.
- MQTT

***MQTT es un protocolo de comunicación ligero basado en el modelo publicación/suscripción. Es muy usado en IoT porque permite enviar datos en tiempo real con bajo consumo de ancho de banda.***

En este proyecto, MQTT permite la comunicación entre:

- El ESP32.
- El broker MQTT.
- Node-RED.
- El sistema de control de la bomba.


## Componentes del sistema
### Sensor DHT11

**El sensor DHT11 mide la temperatura y la humedad del ambiente. Esta información permite conocer las condiciones ambientales alrededor de la planta y determinar si la temperatura puede influir en la necesidad de riego.**

#### Variables capturadas:

- Temperatura ambiente.
- Humedad del aire.
- Sensor de humedad del suelo HW-390

***El sensor HW-390 mide la humedad presente en la tierra. Esta variable es una de las más importantes del sistema, ya que permite identificar si la planta necesita agua.***

#### Variable capturada:

- Humedad del suelo.
- Mini bomba de agua de 3V

***La mini bomba de agua funciona como el actuador principal del sistema. Se activa cuando las condiciones indican que la planta necesita riego.***

##### La bomba se enciende cuando:

- La humedad del suelo indica que la tierra está seca.
- La temperatura ambiente supera el límite definido.

##### La bomba se apaga cuando:

La humedad del suelo alcanza un nivel adecuado.
- Node-RED envía el comando de apagado.
- Simulador de materita virtual

***El proyecto incluye un simulador que genera datos similares a los del nodo físico. Además, cuenta con una representación visual de una materita virtual para observar el comportamiento del sistema de forma gráfica.***

#### Este simulador permite:

- Probar el sistema sin usar el hardware físico.
- Generar lecturas de temperatura, humedad del aire y humedad del suelo.
- Validar el flujo de procesamiento en Node-RED.
- Probar el dashboard y las alertas.

  <img width="491" height="772" alt="image" src="https://github.com/user-attachments/assets/6a0ae03a-46ec-4916-bc00-074b90ea9b43" />


#### Variables capturadas
##### Humedad del suelo

***La humedad del suelo permite identificar si la tierra se encuentra seca, húmeda o en un nivel adecuado para la planta.***

**Procesamiento:**

- Si la humedad del suelo es mayor a 3000, se interpreta como suelo seco.
- Si la humedad del suelo es menor o igual a 2500, se interpreta como suelo en estado normal.
- Si el suelo está seco, se puede generar una alerta de suelo seco.
- Temperatura ambiente

*La temperatura ambiente influye en la evaporación del agua y en la necesidad hídrica de la planta.*

**Procesamiento:**

- Si la temperatura supera los 26 °C, se genera una alerta de temperatura alta.
- Si la temperatura se encuentra por debajo del límite, se considera una temperatura normal.
- Humedad del aire

***La humedad del aire permite complementar el análisis ambiental de la planta. Esta variable ayuda a interpretar las condiciones del entorno y puede ser utilizada para análisis estadísticos y monitoreo general.***

### Node ID

- El node_id permite identificar el origen de la lectura. Esto es útil porque el sistema puede recibir datos desde el ESP32 real o desde un simulador.

### Timestamp

- El timestamp permite conocer el momento exacto en que se capturó la lectura. Esta variable es importante para trazabilidad, análisis histórico, series de tiempo e imputación de datos.


## Procesamiento de datos en Node-RED

Node-RED procesa los datos recibidos desde MQTT y realiza diferentes tareas.

### Validación de datos

Antes de procesar una lectura, el sistema valida que existan las variables críticas:

- Temperatura.
- Humedad del suelo.
- Node ID.
- Timestamp.

***Si una lectura no contiene los datos necesarios, puede ser descartada o registrada como incidencia.**

## Generación de estados

***El sistema clasifica el estado del entorno según las condiciones definidas.***


***El sistema puede generar las siguientes alertas:***

- Alerta de suelo seco.
- Alerta de temperatura alta.
- Alerta de necesidad de riego.
- Estado de suelo normal.

***Cada alerta se almacena con información relevante como:***

- ID de lectura.
- Tipo de alerta.
- Timestamp de la alerta.
- Actuación automática

##### La actuación principal del sistema es el control automático de la bomba de agua.

<img width="1112" height="472" alt="image" src="https://github.com/user-attachments/assets/1f4d2f3a-bdd6-46c6-9381-1c52a6f8f6a2" />


## API REST en Node-RED

Además del procesamiento mediante MQTT, el proyecto incorpora una API REST desarrollada en Node-RED. Esta API permite consultar, exponer y consumir información del sistema de riego inteligente mediante peticiones HTTP.

Una API REST es una interfaz que permite la comunicación entre aplicaciones utilizando el protocolo HTTP. A través de diferentes endpoints, una aplicación puede solicitar datos, enviar información o ejecutar acciones específicas.

En este proyecto, la API REST permite que el sistema pueda exponer información importante del nodo IoT, los datos recolectados, las alertas generadas, las métricas estadísticas y el estado de la bomba de riego.

<img width="806" height="672" alt="image" src="https://github.com/user-attachments/assets/718c271b-8aa2-424e-9f46-e7e0d0341846" />


## Dashboard informativo

El proyecto incluye un dashboard donde se visualiza el estado general del sistema.

**El dashboard muestra información como:**

- Estado general del nodo.
- Datos capturados por los sensores.
- Temperatura ambiente.
- Humedad del aire.
- Humedad del suelo.
- Estado de la bomba.
- Alertas generadas.
- Métricas estadísticas.
- Indicadores de calidad del dato.
- Información del nodo hardware o simulador.
- Estado de control del riego.

***Este dashboard permite monitorear el comportamiento del sistema en tiempo real y facilita la interpretación de los datos recolectados.***

<img width="1600" height="832" alt="image" src="https://github.com/user-attachments/assets/f97403b8-6029-413b-9e16-cba4c4618ad9" />

## Requisitos previos

**Para ejecutar el proyecto se requiere tener instalado:**

- Git.
- Docker.
- Docker Compose.
- Visual Studio Code.
- PlatformIO.
- Python.
- Navegador web.
- Cuenta o acceso a un broker MQTT.
