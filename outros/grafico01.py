
import random
from itertools import count
import matplotlib.pyplot as plt

from matplotlib.animation import FuncAnimation

DELAY = 0

figure, axes = plt.subplots()
xdata, ydata = [], []

plt.style.use('fivethirtyeight')
line, = plt.plot([], [])

index = count()

def init():
  axes.set_xlim(0, 1000)
  axes.set_ylim(0, 6)
  return line,

def update(frame):

  xdata.append(next(index))
  ydata.append(random.randint(0, 5))

  line.set_data(xdata, ydata)
  return line,

animation = FuncAnimation(figure, update, init_func=init, blit=True, interval=DELAY)

plt.tight_layout()
plt.show()