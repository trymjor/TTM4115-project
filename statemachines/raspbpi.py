#from stmpy import Machine
import stmpy
from stmpy import Driver, Machine
from threading import Thread
import paho.mqtt.client as mqtt
from sense_hat import SenseHat
#from graphviz import Source #skal man ha d her

broker, port = "test.mosquitto.org", 8080

l1 = "#00000" #fikse lysa sånn idk
l2 = "#10000"
sense = SenseHat()

#STM
class Raspberry_Pi:
    def on_init(self):
        print("Init!")
        sense.clear()


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
        for x in range(4):
            for y in range(8):
                sense.set_pixel(x,y,(0,87,184))

    def turn_chess_light_on(self):
        print("Slo på sjakk lys")
        for x in range(4,8):
            for y in range(8):
                sense.set_pixel(x,y,(254,221,0))
    
    def turn_vc_light_off(self):
        print("Slo av vc lyset")
        for x in range(4):
            for y in range(8):
                sense.set_pixel(x,y,(0,0,0))

    def turn_chess_light_off(self):
        print("Slo av sjakk lyset")
        for x in range(4,8):
            for y in range(8):
                sense.set_pixel(x,y,(0,0,0))

# Transitions
init = {
    'source': 'initial',
    'target': 'idle',
    'effect': 'on_init; turn_chess_light_off; turn_chess_light_off'}

#Chess
chess_turn_enabled = {
    'trigger': 'chess_turn',
    'source': 'idle',
    'target': 'chess',
    'effect': 'turn_chess_light_on'}

chess_turn_disabled = {
    'trigger': 'not_chess_turn',
    'source': 'chess',
    'target': 'idle',
    'effect': 'turn_chess_light_off'}

#VC
videocall_enable = {
    'trigger': 'first_person_remote',
    'source': 'idle',
    'target': 'videocall',
    'effect': 'turn_vc_light_on;start_timer("t", "60000")'}

videocall_disable = {
    'trigger': 't',
    'source': 'videocall',
    'target': 'idle',
    'effect': 'turn_vc_light_off'}


#Both
vc_to_chess = {
    'trigger': 'chess_turn',
    'source': "videocall",
    'target': "vc_chess",
    'effect': 'turn_chess_light_on'}

chess_to_vc_1 = {
    'trigger': 'first_person_remote',
    'source': 'chess',
    'target': 'vc_chess',
    'effect': 'turn_vc_light_on'}

exit_to_chess = {
    'trigger': 't',
    'source': 'vc_chess',
    'target': 'chess',
    'effect': 'turn_vc_light_off'}

exit_to_vc = {
    'trigger': 'not_chess_turn',
    'source': 'vc_chess',
    'target': 'videocall',
    'effect': 'turn_chess_light_off'}


#States
idle = {
    'name': 'idle'}

chess = {
    'name': 'chess'}

videocall = {
    'name': 'videocall'}

vc_chess = {
    'name': 'vc_chess'}


#MQTT
class MQTT_Client_1:
    def __init__(self):
        self.count = 0
        self.client = mqtt.Client(transport="websockets")
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message

    def on_connect(self, client, userdata, flags, rc):
        print("on_connect(): {}".format(mqtt.connack_string(rc)))
        self.stm_driver.send("chess_turn", "raspb_pi")

    def on_message(self, client, userdata, msg):
        print("on_message(): topic: {}".format(msg.topic))
        if(msg.topic == "zoom_room"):
            self.stm_driver.send("first_person_remote", "raspb_pi")
            
        message_split = msg.payload.decode("utf-8").split(" ")
        if(len(message_split) < 2):
            return
        if(message_split[1] == "w"):
            self.stm_driver.send("chess_turn", "raspb_pi")
        else:
            self.stm_driver.send("not_chess_turn", "raspb_pi")

    def start(self, broker, port):

        print("Connecting to {}:{}".format(broker, port))
        self.client.connect(broker, port)

        self.client.subscribe("ramindra3")
        self.client.subscribe("zoom_room")

        try:
            # line below should not have the () after the function!
            thread = Thread(target=self.client.loop_forever)
            thread.start()
        except KeyboardInterrupt:
            print("Interrupted")
            self.client.disconnect()



raspb = Raspberry_Pi()
raspb_pi_machine = Machine(name='raspb_pi', transitions=[init, chess_turn_enabled, chess_turn_disabled, videocall_enable, videocall_disable, vc_to_chess, chess_to_vc_1, exit_to_chess, exit_to_vc], obj=raspb, states=[idle, chess, videocall, vc_chess])
raspb.stm = raspb_pi_machine


driver = Driver()
driver.add_machine(raspb_pi_machine)

myclient = MQTT_Client_1()
raspb.mqtt_client = myclient.client
myclient.stm_driver = driver

driver.start()
myclient.start(broker, port)

