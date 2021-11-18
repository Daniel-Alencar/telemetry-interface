#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 0
DEVICE = '/dev/ttyACM0'
BAUD = 115200

figure, axes = plt.subplots(ncols=1, nrows=1)
plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()

arduinoData = serial.Serial(DEVICE, BAUD)

def update(frame):
  valueSerial = getValue()
  if valueSerial != None:
    x_vals.append(next(index))
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
  VALUE_SERIAL = str()
  if arduinoData.isOpen():
    VALUE_SERIAL = (arduinoData.readline().decode())
  else:
    VALUE_SERIAL = 512
  print(VALUE_SERIAL)

  if isnumber(VALUE_SERIAL):
    return int(VALUE_SERIAL)


animation = FuncAnimation(figure, update, interval=DELAY)

plt.tight_layout()
plt.show()