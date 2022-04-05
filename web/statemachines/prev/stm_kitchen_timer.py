from stmpy import Machine, Driver

import ipywidgets as widgets
from IPython.display import display

class KitchenTimer:
    
    def on_button_press(self, b):
        self.stm.send('switch') # <---- here we send a signal
            
    def __init__(self):
        # load images and store them
        self.on_60 = open("images/timer/on_60.jpg", "rb").read()
        self.off_60 = open("images/timer/off_60.jpg", "rb").read()
        self.on_45 = open("images/timer/on_45.jpg", "rb").read()
        self.off_45 = open("images/timer/off_45.jpg", "rb").read()
        self.on_30 = open("images/timer/on_30.jpg", "rb").read()
        self.off_30 = open("images/timer/off_30.jpg", "rb").read()
        self.on_15 = open("images/timer/on_15.jpg", "rb").read()
        self.off_15 = open("images/timer/off_15.jpg", "rb").read()
        self.plug_on = open("images/timer/plug_on.jpg", "rb").read()
        self.plug_off = open("images/timer/plug_off.jpg", "rb").read()
        
        self.led_15 = widgets.Image(value=self.off_15, format='jpg', width=50, height=50)
        self.led_30 = widgets.Image(value=self.off_30, format='jpg', width=50, height=50)
        self.led_45 = widgets.Image(value=self.off_45, format='jpg', width=50, height=50)
        self.led_60 = widgets.Image(value=self.off_60, format='jpg', width=50, height=50)
        
        left_box = widgets.VBox([self.led_60, self.led_45])
        right_box = widgets.VBox([self.led_15, self.led_30])
        box = widgets.HBox([left_box, right_box])
        self.plug = widgets.Image(value=self.plug_off, format='jpg', width=100, height=100)
        
        # display the user interface
        # a button
        self.button = widgets.Button(description="Button")
        self.button.on_click(self.on_button_press)
        
        display(box, self.button, self.plug)
        
    
    def switch_led(self, led, on):
        if led == '15' and on: self.led_15.set_trait(name='value', value=self.on_15)
        if led == '15' and not on: self.led_15.set_trait(name='value', value=self.off_15) 
        if led == '30' and on: self.led_30.set_trait(name='value', value=self.on_30)
        if led == '30' and not on: self.led_30.set_trait(name='value', value=self.off_30) 
        if led == '45' and on: self.led_45.set_trait(name='value', value=self.on_45)
        if led == '45' and not on: self.led_45.set_trait(name='value', value=self.off_45) 
        if led == '60' and on: self.led_60.set_trait(name='value', value=self.on_60)
        if led == '60' and not on: self.led_60.set_trait(name='value', value=self.off_60) 
            
    def switch_plug(self, on):
        if on: self.plug.set_trait(name='value', value=self.plug_on)
        else: self.plug.set_trait(name='value', value=self.plug_off) 

kt = KitchenTimer() 

  

off = {"name": "off", 
      "entry": "set_leds(); switch_plug(False)", 
      "exit": "start_timer('t', '4000'); switch_plug(True)"} 

  

one_led = {"name": "one_led", 
           "entry": "switch_led('15', True)", 
           "exit": "start_timer('t', '4000')"} 

two_led = {"name": "two_led", 
           "entry": "switch_led('30', True)", 
           "exit": "start_timer('t', '4000')"} 

three_led = {"name": "three_led", 
             "entry": "switch_led('45', True)", 
             "exit": "start_timer('t', '4000')"} 

four_led = {"name": "four_led", 
            "entry": "switch_led('60', True)", 
            "exit": "start_timer('t', '4000')"} 

  

init = {"source": "initial", 
        "target": "off"} 
  

s1 = {"source": "off", 
      "target": "one_led", 
      "trigger": "switch"} 

s2 = {"source": "one_led", 
      "target": "two_led", 
      "trigger": "switch"}

s3 = {"source": "two_led", 
      "target": "three_led", 
      "trigger": "switch"} 

s4 = {"source": "three_led", 
      "target": "four_led", 
      "trigger": "switch"} 

s5 = {"source": "four_led", 
      "target": "off", 
      "trigger": "switch"} 

  

t1 = { 
    "source": "one_led", 
    "target": "off", 
    "trigger": "t", 
    "effect": "switch_led('15', False)" 
} 
  

t2 = { 
    "source": "two_led", 
    "target": "one_led", 
    "trigger": "t",
    "effect": "switch_led('30', False)" 
} 


t3 = { 
    "source": "three_led", 
    "target": "two_led", 
    "trigger": "t", 
    "effect": "switch_led('45', False)" 
}


t4 = { 
    "source": "four_led", 
    "target": "three_led", 
    "trigger": "t", 
    "effect": "switch_led('60', False)" 
} 

  

stm_kt = Machine(name='stm_kt', transitions=[init, t1, t2, t3, t4, s1, s2, s3, s4, s5], obj=kt, states=[off, one_led, two_led, three_led, four_led]) 

kt.stm = stm_kt 

  

driver = Driver() 

driver.add_machine(stm_kt) 

driver.start() 