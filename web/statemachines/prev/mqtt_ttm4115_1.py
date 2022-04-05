
import paho.mqtt.client as mqtt
from threading import Thread
broker, port = "mqtt.item.ntnu.no", 1883


class MQTT_Client_1:
    def __init__(self):
        self.count = 0
        print(self.count)

    def on_connect(self, client, userdata, flags, rc):
        print("on_connect(): {}".format(mqtt.connack_string(rc)))

    def on_message(self, client, userdata, msg):
        print("on_message(): topic: {}".format(msg.topic))
        self.count = self.count + 1
        if self.count == 20:
            self.client.disconnect()
            print("disconnected after 20 messages")

    def start(self, broker, port):
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        print("Connecting to {}:{}".format(broker, port))
        self.client.connect(broker, port)

        print("Connected to {}:{}".format(broker, port))
        subscrib = "gruppe9/#"
        self.client.subscribe(subscrib)
        print("Subscribed to {}".format(subscrib))

        try:
            thread = Thread(target=self.client.loop_forever)
            thread.start()
        except KeyboardInterrupt:
            print("Interrupted")
            self.client.disconnect()

myclient = MQTT_Client_1()
myclient.start(broker, port)