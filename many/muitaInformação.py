import time
from itertools import count
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

import serial

DELAY = 500
DEVICE = '/dev/ttyACM0'
BAUD = 9600

figure, axes = plt.subplots(ncols=2, nrows=2)

x_vals = [[],[]]
y_vals = [[],[]]

index = count()
arduinoData = serial.Serial(DEVICE, BAUD, timeout=5)

def update(frame):
  valueSerial = getValue()

  count = next(index)
  for c in range(2):
    print("Value C:", c)
    if valueSerial[c] != None:
      x_vals[c].append(count)
      y_vals[c].append(valueSerial[c])
  
  print("=========================================================================")
  
  axes[0, 0].clear()
  axes[0, 1].clear()
  axes[1, 0].clear()

  axes[0, 0].set_title("Altitude sensor")
  axes[0, 0].set_xlabel("Time")
  axes[0, 0].set_ylabel("Altitude (m)")

  axes[0, 1].set_title("Temperature sensor")
  axes[0, 1].set_xlabel("Time")
  axes[0, 1].set_ylabel("Temperature (K)")

  axes[1, 0].set_title("Acelerometer sensor")
  axes[1, 0].set_xlabel("Time")
  axes[1, 0].set_ylabel("Aceleration (m/s^2)")

  
  plt.tight_layout()

  axes[0, 0].plot(x_vals[0], y_vals[0])
  axes[0, 1].plot(x_vals[1], y_vals[1])
  axes[1, 0].plot(x_vals[0], y_vals[0])


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

    string = arduinoData.read(28).decode()
    
  print("=>",string)
  arrayString = string.split(',')
  arrayNumber = []

  for value in arrayString:
    if isnumber(value):
      arrayNumber.append(float(value))
  print(arrayNumber)
  return arrayNumber

animation = FuncAnimation(figure, func=update, blit=False, interval=DELAY)

plt.tight_layout()
plt.show()