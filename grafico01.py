#!/usr/bin/python
# -*- coding: iso-8859-1 -*-
import time
import serial

import matplotlib.pyplot as plt
from matplotlib import animation

DELAY = 0.100
DEVICE='/dev/ttyACM0'
BAUD=9600

# Iniciando conexao serial
comport = serial.Serial(DEVICE, BAUD)
fig, ax = plt.subplots()

def animar():
  count = 0
  start = time.time()
  while count < 10:
    VALUE_SERIAL = comport.readline().decode()
    print('\n%s' % (VALUE_SERIAL))

    data = []
    timeList = []
    data.append(int(VALUE_SERIAL))

    end = time.time()
    timeList.append(end - start)

    time.sleep(DELAY)
    count += 1
  
  ax.clear()
  ax.plot(timeList, data)

animar()
plt.show()