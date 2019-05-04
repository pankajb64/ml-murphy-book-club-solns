from nb import NaiveBayes
import numpy as np
import scipy.io as sio

from sklearn.metrics import zero_one_loss

#change this to where
mat_dict = sio.loadmat('XwindowsDocData.mat')

Xtrain = mat_dict['xtrain'].toarray()
Xtest = mat_dict['xtest'].toarray()

ytrain = mat_dict['ytrain'].flatten()
ytest = mat_dict['ytest'].flatten()

nb = NaiveBayes()
pi, theta = nb.fit(Xtrain, ytrain)

ypred_train = nb.predict(Xtrain)
ypred_test = nb.predict(Xtest)

print(ypred_train)
print(ypred_test)

#because the classes are 1,2
ypred_train = 1 + ypred_train.argmax(axis=1)
ypred_test = 1 + ypred_test.argmax(axis=1)

print(ypred_train[-20:])
print(ytrain[-20:])
print(ypred_test[-20:])
print(ytest[-20:])

print('Misclassification Rate: Train: {}%'.format(zero_one_loss(ytrain, ypred_train, normalize=True) * 100))
print('Misclassification Rate: Test:  {}%'.format(zero_one_loss(ytest, ypred_test, normalize=True) * 100))
