#!/usr/bin/python
import gpiod
import time
chip = gpiod.Chip('9008000.gpio')
switch0 = chip.get_line(0)
switch0.request(consumer="its_me", type=gpiod.LINE_REQ_EV_BOTH_EDGES)
while True:
   ev_line = switch0.event_wait(sec=2)
   if ev_line:
     event = switch0.event_read()
     print(event)
   else:
     print(".")

