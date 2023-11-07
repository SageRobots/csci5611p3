import numpy as np

# parabola solver
x1 = 100
x2 = 150
x3 = 200
y1 = -100
y2 = -200
y3 = -100

y = np.array([[y1], [y2], [y3]])
x = np.array([[x1**2, x1, 1], [x2**2, x2, 1], [x3**2, x3, 1]])
a = np.linalg.solve(x, y)
print(a)