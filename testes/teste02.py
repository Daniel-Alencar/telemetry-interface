
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

figure, axes = plt.subplots()
xdata, ydata = [], []
line, = plt.plot([], [], 'ro')

def init():
    axes.set_xlim(0, 2*np.pi)
    axes.set_ylim(-1, 1)
    return line,

def update(frame):
    xdata.append(frame)
    ydata.append(np.sin(frame))
    line.set_data(xdata, ydata)
    return line,

ani = FuncAnimation(figure, update, frames=np.linspace(0, 2*np.pi, 128),
                    init_func=init, blit=True)
plt.show()