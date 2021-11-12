import random
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt

from matplotlib.animation import FuncAnimation

import time
import serial

DELAY = 0.100
DEVICE='/dev/ttyACM0'
BAUD=9600

plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()

def animate(i):
  x_vals.append(next(index))
  y_vals.append(getValue())

  print(x_vals)
  print(y_vals)
  
  plt.cla()
  plt.plot(x_vals, y_vals)

def getValue():
  arduinoData = serial.Serial(DEVICE, BAUD)

  VALUE_SERIAL = int(arduinoData.readline().decode())

  arduinoData.close()
  return VALUE_SERIAL

animation = FuncAnimation(plt.gcf(), animate, interval=100)

plt.tight_layout()
plt.show()