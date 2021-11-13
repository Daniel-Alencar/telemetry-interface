from itertools import count
import matplotlib.pyplot as plt

from matplotlib.animation import FuncAnimation

import serial

DELAY = 100
DEVICE='/dev/ttyACM0'
BAUD=9600

figure, axes = plt.subplots(ncols=2, nrows=2)
plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()

arduinoData = serial.Serial(DEVICE, BAUD)

def animate(i):
  x_vals.append(next(index))

  valueSerial = getValue()
  y_vals.append(valueSerial)

  print(valueSerial)
  
  axes[0, 0].clear()
  axes[0, 1].clear()
  axes[1, 0].clear()
  axes[1, 1].clear()

  axes[0, 0].plot(x_vals, y_vals)
  axes[0, 1].plot(x_vals, y_vals)
  axes[1, 0].plot(x_vals, y_vals)
  axes[1, 1].plot(x_vals, y_vals)

def isnumber(value):
  try:
    float(value)
  except ValueError:
    return False
  return True

def getValue():
  VALUE_SERIAL = (arduinoData.readline().decode())
  
  if isnumber(VALUE_SERIAL) and VALUE_SERIAL != None:
    return int(VALUE_SERIAL)


animation = FuncAnimation(plt.gcf(), animate, interval=DELAY)

plt.tight_layout()
plt.show()