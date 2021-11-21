#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 0
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
  if valueSerial != None:
    c = next(index)
    x_vals.append(c)
    y_vals.append(valueSerial)

  plt.cla()
  plt.plot(x_vals, y_vals)

def isnumber(value):
  try:
    float(value)
  except ValueError:
    return False
  return True

def getValue():
  string = ""
  if arduinoData.isOpen():
    bytesToRead = arduinoData.inWaiting()
    string = arduinoData.read(bytesToRead).decode()
    
  print(string)
  if isnumber(string):
    return float(string)


animation = FuncAnimation(figure, update, interval=DELAY)

plt.tight_layout()
plt.show()