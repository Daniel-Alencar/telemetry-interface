# importing packages
import numpy as np
import matplotlib.pyplot as plt
  
# create data
x=np.array([1, 2, 3, 4, 5])
  
# making subplots
fig, ax = plt.subplots(2, 2)
  
# set data with subplots and plot
ax[0, 0].plot(x, x)
ax[0, 1].plot(x, x*2)
ax[1, 0].plot(x, x*x)
ax[1, 1].plot(x, x*x*x)
  
# set the title to subplots
ax[0, 0].set_title("Linear")
ax[0, 1].set_title("Double")
ax[1, 0].set_title("Square")
ax[1, 1].set_title("Cube")
  
# set spacing
fig.tight_layout()
plt.show()