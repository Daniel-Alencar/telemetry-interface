#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

import matplotlib.pyplot as plt

from matplotlib.animation import FuncAnimation

x = [0,1,2,3,4,5]
y = [0,1,2,3,4,5]

figure, axes = plt.subplots(ncols=2, nrows=2)
axes[0, 0].plot(x,y)
axes[0, 1].plot(x,y)
axes[1, 0].plot(x,y)
axes[1, 1].plot(x,y)

plt.show()