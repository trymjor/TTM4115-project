import paho.mqtt.client as mqtt
from threading import Thread
broker, port = "mqtt.item.ntnu.no", 1883
import time


class MQTT_Client_1:
    def __init__(self):
        self.count = 0

    def on_connect(self, client, userdata, flags, rc):
        print("on_connect(): {}".format(mqtt.connack_string(rc)))

    def on_message(self, client, userdata, msg):
        print("on_message(): topic: {}".format(msg.topic))

    def start(self, broker, port):
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        print("Connecting to {}:{}".format(broker, port))
        self.client.connect(broker, port)

        self.client.subscribe("ttm4115/#")

        try:
            thread = Thread(target=self.client.loop_forever)
            thread.start()
            self.count = self.count + 1
            while(self.count<20):
                    
                try:
                    place1 = "gruppe9/raspb_pi/status/chess"
                    place2 = "gruppe9/raspb_pi/status/vc"
                    print("Sending messages")
                    self.client.publish(place2, "first_person_remote")
                    time.sleep(5)
                    self.client.publish(place2, "no_people_left")
                    time.sleep(5)
                    self.client.publish(place1, "chess_turn")
                    time.sleep(5)
                    self.client.publish(place1, "not_chess_turn")
                    time.sleep(5)
                    '''
                    self.client.publish(place2, "first_person_remote")
                    time.sleep(5)
                    self.client.publish(place1, "chess_turn")
                    time.sleep(5)
                    self.client.publish(place2, "no_people_left")
                    time.sleep(5)
                    self.client.publish(place1, "not_chess_turn")
                    time.sleep(5)'''
                    print("Finished sending messages")
                    

                    #print("Printing payload: {} in {}?".format(msg.payload, place1))
                except Exception as e:
                    print(e)

            
        except KeyboardInterrupt:
            print("Interrupted")
            self.client.disconnect()


myclient = MQTT_Client_1()
myclient.start(broker, port)