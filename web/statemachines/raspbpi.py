from stmpy import Machine
import stmpy
#from graphviz import Source #skal man ha d her

# Transitions
initate = {'source': 'initial',
           'target': 'idle'}

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
         'entry': 'turn_light_on("l1")',
         'exit': 'turn_light_off("l1")'}

videocall = {'name': 'videocall',
             'entry': 'turn_light_on("l2")',
             'exit': 'turn_light_off("l2")'}


'''
stm_Raspberry = Machine(name='stm_Raspberry', transitions=[initial, chess_turn_enabled, chess_turn_disabled, videocall_enable_1, videocall_enable_2, videocall_disable], obj=None, states=[idle, chess, videocall])

dot = stmpy.get_graphviz_dot(stm_Raspberry)
src = Source(dot)
src
'''