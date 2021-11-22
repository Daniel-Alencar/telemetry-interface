#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 1000
DEVICE = '/dev/ttyACM0'
BAUD = 9600

figure, axes = plt.subplots(ncols=1, nrows=2)
plt.style.use('fivethirtyeight')

x_vals = [[],[]]
y_vals = [[],[]]

index = count()
arduinoData = serial.Serial(DEVICE, BAUD)

def update(frame):
  valueSerial = getValue()
  count = 0

  count = next(index)
  for c in range(2):
    print("Value C:", c)
    if valueSerial[c] != None:
      x_vals[c].append(count)
      y_vals[c].append(valueSerial[c])
  
  plt.cla()
  
  plt.tight_layout()
  axes[0].clear()
  axes[1].clear()
  axes[0].plot(x_vals[0], y_vals[0])
  axes[1].plot(x_vals[1], y_vals[1])

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
  arrayString = string.split(',')
  arrayNumber = []

  for value in arrayString:
    if isnumber(value):
      arrayNumber.append(float(value))
  print("Length:", arrayNumber.__len__())
  return arrayNumber

animation = FuncAnimation(figure, func=update, blit=False, interval=DELAY)

plt.tight_layout()
plt.show()