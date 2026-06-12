import json
import time
import random
import ssl
from datetime import datetime
import paho.mqtt.client as mqtt


MQTT_SERVER = "00bb4b8f25504bcb8380dce5fdd8cf37.s1.eu.hivemq.cloud"
MQTT_PORT = 8883
MQTT_USER = "Parcial2_Datos"
MQTT_PASS = "Parcial2_Datos"

TOPIC_DATOS = "Parcial2_Datos"

# Este topico es el que Node-RED debe usar para prender la pagina
TOPIC_ACTUACION_PAGINA = "Parcial2_Pagina"

NODE_ID = "PYTHON_VIRTUAL_1"

bomba_virtual = False

# En sensores analogicos de humedad de suelo:
# valor alto = suelo seco
# valor bajo = suelo humedo
humedad_suelo = 3300


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Conectado a HiveMQ")

        # Python escucha la misma actuacion que vera la pagina
        client.subscribe(TOPIC_ACTUACION_PAGINA)
        print("Suscrito a:", TOPIC_ACTUACION_PAGINA)
    else:
        print("Error de conexion:", rc)


def on_message(client, userdata, msg):
    global bomba_virtual
    global humedad_suelo

    comando = msg.payload.decode()
    print("Comando recibido:", comando)

    if comando == "ON":
        bomba_virtual = True
        print("Materita virtual regandose")

    elif comando == "OFF":
        bomba_virtual = False
        print("Materita virtual apagada")


def crear_datos():
    global humedad_suelo

    # Si la bomba virtual esta encendida, el suelo se humedece
    # Por eso baja el valor analogico
    if bomba_virtual:
        humedad_suelo -= random.randint(120, 250)

    # Si la bomba esta apagada, el suelo se seca lentamente
    else:
        humedad_suelo += random.randint(40, 100)

    # Limites realistas para evitar valores raros
    humedad_suelo = max(1800, min(4095, humedad_suelo))

    datos = {
        "node_id": NODE_ID,

        # Temperatura realista para ambiente caluroso
        # Suficiente para activar si en Node-RED usas temperatura > 30
        "temperatura": round(random.uniform(35.0, 46.5), 2),

        # Humedad de aire normal
        "humedad_aire": round(random.uniform(45.0, 70.0), 2),

        # Si esta mayor a 3000, Node-RED interpreta suelo seco
        "humedad_suelo": humedad_suelo,

        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    return datos


client = mqtt.Client(
    callback_api_version=mqtt.CallbackAPIVersion.VERSION1,
    client_id="Python_Materita_Virtual"
)

client.username_pw_set(MQTT_USER, MQTT_PASS)

client.tls_set(cert_reqs=ssl.CERT_NONE)
client.tls_insecure_set(True)

client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_SERVER, MQTT_PORT, 60)
client.loop_start()

try:
    while True:
        datos = crear_datos()
        mensaje = json.dumps(datos)

        client.publish(TOPIC_DATOS, mensaje)

        print("Publicado en Parcial2_Datos:")
        print(mensaje)
        print("Estado bomba virtual:", "ON" if bomba_virtual else "OFF")
        print("-" * 40)

        time.sleep(2)

except KeyboardInterrupt:
    print("Finalizando simulacion")

finally:
    client.loop_stop()
    client.disconnect()