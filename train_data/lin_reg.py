import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

#create randData
rnState = np.random.RandomState(1)
x = 10 * rnState.rand(50)
y = 2*x - 5 + rnState.randn(50)

#create linReg model
myModel = LinearRegression(fit_intercept=True)
myModel.fit(x[:,np.newaxis],y)
xfit = np.linspace(0,10,1000)
yfit = myModel.predict(xfit[:,np.newaxis])

#plot
plt.scatter(x,y)
plt.plot(xfit, yfit)
plt.show()
