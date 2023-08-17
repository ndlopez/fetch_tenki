#data manipulation
import numpy as np
import pandas as pd
from datetime import datetime

#plots
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')
plt.rcParams['lines.linewidth'] = 1.5

#modeling and forecasting
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import Lasso
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline

# Require Visual C++ tools, not avail on Windows11

from skforecast.ForecasterAutoreg import ForecasterAutoreg
from skforecast.ForecasterAutoregCustom import ForecasterAutoregCustom
from skforecast.ForecasterAutoregMultiOutput import ForecasterAutoregMultiOutput
from skforecast.model_selection import grid_search_forecaster
from skforecast.model_selection import backtesting_forecaster

from joblib import dump,load
import warnings

#fetch data
# url = 'https://raw.githubusercontent.com/JoaquinAmatRodrigo/skforecast/master/data/h2o_exog.csv'
url = "../data/data_20220802_20220812.csv"

# custom_date_parse = lambda x: datetime.strptime(x, "%Y-%m-%d %H")
# when merging date and hour cols: 
data = pd.read_csv(url,parse_dates={'date_time':[0,1]},sep=',')
# data = pd.read_csv(url,sep=',')
# print(data.head())
# data = data.rename(columns={'fecha':'date'})
data['date_time'] = pd.to_datetime(data['date_time'],format='%Y-%m-%d %H:%M')
# data['hour'] = pd.to_datetime(data['hour'])
data = data.set_index('date_time')
# data= data.rename(columns={'x':'y'})
data = data.asfreq('H') # H: hourly ,MS: Monthly started
data = data.sort_index()
# print(data.head())
# print(data.info())

print(f'number of rows with missing vals: {data.isnull().any(axis=1).mean()}')

# verify that temporary index is complete
# (data.index== pd.date_range(start=data.index.min(),end=data.index.max(),freq=data.index.freq)).all()

# if empty vals then fill in gaps
#data.asfreq(freq='1hour',fill_value=np.nan)

# split data into train-test
# steps=36 # the last 36 months are used as the test to eval the predict capacity of the model
mySteps = 42 # the last 42 hours are used 
data_train = data[:-mySteps]
data_test = data[-mySteps:]

print(f"train dates: {data_train.index.min()} --- {data_train.index.max()} (n={len(data_train)})")
print(f"test dates: {data_test.index.min()} --- {data_test.index.max()} (n={len(data_test)})")
print(data.columns.tolist())

myCol = "temp"
#sample and test data
"""fig, ax= plt.subplots(figsize=(9,4))
data_train[myCol].plot(ax=ax,label='train')
data_test[myCol].plot(ax=ax,label='test')
ax.legend()
plt.show()"""

#create and train forecaster
myForecaster = ForecasterAutoreg(regressor = RandomForestRegressor(random_state=123),lags=6)
myForecaster.fit(y=data_train[myCol])
print(myForecaster)

# predictions
myPredict = myForecaster.predict(steps=mySteps)
print(myPredict.head(5))
#nshould display 5 sets of data
# plot

# test error
error_mse = mean_squared_error(y_true=data_test[myCol],y_pred=myPredict)
print(f"test error (mse):{error_mse}")

# hiperparam tuning: use 12 windows instead of 6
myForecaster = ForecasterAutoreg(regressor = RandomForestRegressor(random_state=123),lags=12)

lagsGrid = [10,20] # as predictors

paramGrid = {'n_estimators':[100,500],'max_depth':[3,5,10]}

result_grid = grid_search_forecaster(forecaster=myForecaster, y = data_train[myCol], 
    param_grid=paramGrid,lags_grid=lagsGrid,steps=mySteps,refit=True, 
    metric='mean_squared_error', initial_train_size= int(len(data_train)*0.5),
    return_best=True,verbose=False)

print(result_grid)

exit()
#Once the above was found re-calc
myRegressor = RandomForestRegressor(max_depth=5, n_estimators=100, random_state=123)

myForecaster = ForecasterAutoreg(regressor=myRegressor,lags=20)
myForecaster.fit(y=data_train[myCol])

# predictors
myPredict = myForecaster.predict(steps=mySteps)

def plot_graph():
    # plot graph
    fig, ax = plt.subplots(figsize=(9,4))
    data_train[myCol].plot(ax=ax,label='train')
    data_test[myCol].plot(ax=ax,label='test')
    myPredict.plot(ax=ax,label='predicted',color='b')
    plt.title("August 2022")
    plt.ylabel('\u2103', style='italic', loc='top')
    ax.legend()
    plt.show()

plot_graph()
# test error
error_mse = mean_squared_error(y_true=data_test[myCol],y_pred=myPredict)
print(f"test error (mse):{error_mse}")