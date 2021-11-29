#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 200
DEVICE = '/dev/ttyACM0'
BAUD = 9600

figure, axes = plt.subplots(ncols=1, nrows=1)
plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()
arduinoData = serial.Serial(DEVICE, BAUD)

def update(frame):
  valueSerial = getValue()
  count = 0
  if valueSerial != None:
    count = next(index)
    x_vals.append(count)
    y_vals.append(valueSerial)
  
  plt.cla()
  
  plt.tight_layout()
  plt.plot(x_vals, y_vals, scalex=True)

def isnumber(value):
  try:
    float(value)
  except ValueError:
    return False
  return True

def getValue():
  string = ""
  if arduinoData.isOpen():
    arduinoData.flushInput()
    string = arduinoData.read(6).decode()
  
  print(string)
  if isnumber(string):
    return float(string)

animation = FuncAnimation(figure, func=update, blit=False, interval=DELAY)

plt.tight_layout()
plt.show()