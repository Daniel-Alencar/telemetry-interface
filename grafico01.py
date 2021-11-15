#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

import random
from itertools import count
import matplotlib.pyplot as plt

from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()

def animate(i):
  x_vals.append(next(index))
  y_vals.append(random.randint(0, 5))
  
  plt.cla()
  plt.plot(x_vals, y_vals)

animation = FuncAnimation(plt.gcf(), animate, interval=1000)

plt.tight_layout()
plt.show()