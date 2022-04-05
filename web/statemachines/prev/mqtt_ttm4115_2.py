import paho.mqtt.client as mqtt
from threading import Thread
broker, port = "mqtt.item.ntnu.no", 1883


class MQTT_Client_1:
    def __init__(self):
        self.count = 0

    def on_connect(self, client, userdata, flags, rc):
        print("on_connect(): {}".format(mqtt.connack_string(rc)))

    def on_message(self, client, userdata, msg):
        print("on_message(): topic: {}".format(msg.topic))
        self.count = self.count + 1
        try:
            msg.payload = "testing"
            print("Printing payload: {} in frank?".format(msg.payload))
            i = 0
            while(i<20):
                i+=1
                self.client.publish("tiktok", "testing {}".format(i))
            print("fin")
        except Exception as e:
            print(e)

        if self.count == 5:
            self.client.disconnect()
            print("disconnected after 5 forwards")

    def start(self, broker, port):
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        print("Connecting to {}:{}".format(broker, port))
        self.client.connect(broker, port)

        self.client.subscribe("ttm4115")

        try:
            thread = Thread(target=self.client.loop_forever)
            thread.start()
        except KeyboardInterrupt:
            print("Interrupted")
            self.client.disconnect()


myclient = MQTT_Client_1()
myclient.start(broker, port)