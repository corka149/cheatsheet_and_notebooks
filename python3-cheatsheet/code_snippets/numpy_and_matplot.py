import matplotlib.pyplot as plt
import numpy as np


# For matplot
def config_plot():
    conf = {}
    conf["color"] = "#f27126"
    conf["linestyle"] = "dotted"
    conf["marker"] = "o"
    # don't forget plt.legend()
    conf["label"] = "just some numbers"

    return conf


y1, y2 = ([1, 2, 3, 4, 5], [6, 7, 8, 9, 10])
y_from_array = np.array([y1, y2])

# 1 to inc. 5
y = np.arange(1, 5)
print(y.shape)  # (4,)

# 3 rows * 4 cols
X_zero = np.zeros((3, 4))
# Scalar addition
X = X_zero + 2
print(X.shape)  # (3,4)

# Matrix multiplication
X_new = np.dot(X, y)
print(X_new.shape)  # (3,)

mean = X_new.mean()
min_X = X_new.min()
max_X = X_new.max()
# standard deviation
std_X = X_new.std()

# Reshape to 1 row and 10 cols as it fits
plot_x = np.arange(1, 11)
plot_y = plot_x ** 2

# placeholder for reshape is -1
X = plot_x.reshape((2, -1))
X = plot_y.reshape((-1, 5))

# Filter
X_lower_fifty = X[X < 50]

"""
Now some matplotlib
"""

plt.plot(plot_x, plot_y, **config_plot())
plt.legend()
plt.show()

plt.pie(plot_x)
plt.show()

plt.bar(plot_x, plot_y)
plt.show()

plt.scatter(plot_x, plot_y, marker="x")
plt.show()
