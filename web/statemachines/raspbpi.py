#from stmpy import Machine
import stmpy
from stmpy import Driver, Machine
from threading import Thread
import paho.mqtt.client as mqtt
#from graphviz import Source #skal man ha d her

broker, port = "mqtt.item.ntnu.no", 1883

l1 = "#00000" #fikse lysa sånn idk
l2 = "#10000"

#STM
class Raspberry_Pi:
    def on_init(self):
        print("Init!")


    def turn_vc_light_on(self):
        #raspberry pi kode for å slå på lys avh. av hvilket lys
        #evt endre så det er en egen kode for sjakklys og et for videolys
        #denne kodebiten skal fortelle rapsberryen at den skal slå på lys
        '''
        self.ticks = self.ticks + 1
        self.mqtt_client.publish("gruppe9/raspb_pi/{}".format(type), "Turning on light {}".format(light))
        '''
        print("Slo på vc lys")
        #blabla kode for å mekke raspberry lys

    def turn_chess_light_on(self):
        print("Slo på sjakk lys")

    def turn_vc_light_off(self):
        '''
        print("Tock! {}".format(self.tocks))
        self.tocks = self.tocks + 1
        self.mqtt_client.publish("gruppe9/raspb_pi/{}".format(type), "Turning off light {}".format(light))
        '''

        print("Slo av vc lys")

    def turn_chess_light_off(self):
        print("Slo av sjakk lys")



# Transitions
init = {'source': 'initial',
        'target': 'idle',
        'effect': 'on_init'}

chess_turn_enabled = {'trigger': 'chess_turn',
                      'source': 'idle',
                      'target': 'chess'}

chess_turn_disabled = {'trigger': 'not_chess_turn',
                       'source': 'chess',
                       'target': 'idle'}

videocall_enable_1 = {'trigger': 'first_person_remote',
                      'source': 'idle',
                      'target': 'videocall'}

videocall_enable_2 = {'trigger': 'first_person_detected',
                      'source': 'idle',
                      'target': 'videocall'}

videocall_disable = {'trigger': 'no_people_left',
                     'source': 'videocall',
                     'target': 'idle'}


#States
idle = {'name': 'idle'}

chess = {'name': 'chess',
         'entry': 'turn_chess_light_on',
         'exit': 'turn_chess_light_off'}

videocall = {'name': 'videocall',
             'entry': 'turn_vc_light_on',
             'exit': 'turn_vc_light_off'}


#MQTT
class MQTT_Client_1:
    def __init__(self):
        self.count = 0
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message

    def on_connect(self, client, userdata, flags, rc):
        print("on_connect(): {}".format(mqtt.connack_string(rc)))

    def on_message(self, client, userdata, msg):
        
        print("on_message(): topic: {}".format(msg.topic))
        self.stm_driver.send(msg.payload.decode("utf-8"), "raspb_pi")

    def start(self, broker, port):

        print("Connecting to {}:{}".format(broker, port))
        self.client.connect(broker, port)

        self.client.subscribe("gruppe9/raspb_pi/status/#")

        try:
            # line below should not have the () after the function!
            thread = Thread(target=self.client.loop_forever)
            thread.start()
        except KeyboardInterrupt:
            print("Interrupted")
            self.client.disconnect()



raspb_pi = Raspberry_Pi()
raspb_pi_machine = Machine(name='raspb_pi', transitions=[init, chess_turn_enabled, chess_turn_disabled, videocall_enable_1, videocall_enable_2, videocall_disable], obj=None, states=[idle, chess, videocall])
raspb_pi.stm = raspb_pi_machine


driver = Driver()
driver.add_machine(raspb_pi_machine)

myclient = MQTT_Client_1()
raspb_pi.mqtt_client = myclient.client
myclient.stm_driver = driver

driver.start()
myclient.start(broker, port)
