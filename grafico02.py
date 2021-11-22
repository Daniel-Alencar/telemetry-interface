#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

# from itertools import count
# import matplotlib.pyplot as plt
# from matplotlib.animation import FuncAnimation

# import serial

# DELAY = 10
# DEVICE = '/dev/ttyACM0'
# BAUD = 9600

# figure, axes = plt.subplots(ncols=1, nrows=1)
# plt.style.use('fivethirtyeight')

# x_vals = []
# y_vals = []
# line, = plt.plot([], [])

# index = count()
# arduinoData = serial.Serial(DEVICE, BAUD)

# def init():
#   return line,

# def update(frame):
#   valueSerial = getValue()
#   count = 0
#   if valueSerial != None:
#     count = next(index)
#     x_vals.append(count)
#     y_vals.append(valueSerial)
  
#   plt.cla()
#   plt.autoscale()

#   if count >= 50:
#     axes.set_xlim(x_vals[count - 50], x_vals[count])
  
#   line.set_data(x_vals, y_vals)
#   plt.tight_layout()
#   plt.plot(x_vals, y_vals, scalex=True)
#   return line,

# def isnumber(value):
#   try:
#     float(value)
#   except ValueError:
#     return False
#   return True

# def getValue():
#   string = ""
#   if arduinoData.isOpen():
#     bytesToRead = arduinoData.inWaiting()
#     string = arduinoData.read(bytesToRead).decode()
    
#   print(string)
#   if isnumber(string):
#     return float(string)


# animation = FuncAnimation(figure, init_func=init, func=update, blit=True, interval=DELAY)

# plt.tight_layout()
# plt.show()

#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-
import time
from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 10
DEVICE = '/dev/ttyACM0'
BAUD = 9600

figure, axes = plt.subplots(ncols=1, nrows=1)
plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()

arduinoData = serial.Serial(DEVICE, BAUD)

def init():
  axes.set_xlim(0, 50)

def update(frame):
  valueSerial = getValue()
  count = 0

  print("ValueSerial:", valueSerial)
  if valueSerial != None:
    count = next(index)
    # print("Count:", count)

    x_vals.append(count)
    y_vals.append(valueSerial)
  
  plt.cla()

  resto = count % 50

  # print("Resto:", resto)
  if resto == 0:
    axes.set_xlim(count, count + 50)

  plt.plot(x_vals, y_vals)
  plt.tight_layout()


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
    
  # print(string)
  if isnumber(string):
    return float(string)


animation = FuncAnimation(figure, init_func=init, func=update, interval=DELAY)

plt.tight_layout()
plt.show()