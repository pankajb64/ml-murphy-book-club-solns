import numpy as np
import pandas as pd
from scipy.special import logsumexp

class NaiveBayes:

	def __init__(self):
		self.pi = np.empty((0))
		self.theta = np.empty((0))

	def fit(self, X, y):
		#Based on Murphy Algorithm 3.1
		#assume xj is binary features
		df = pd.DataFrame(X)
		df['class'] = y
		
		C = len(df['class'].unique())
		#Priors: alpha = 1 and beta = 1 ( = beta0 = beta1) (vectors)
		alpha = 1
		beta = 1

		class_counts = df.groupby('class')['class'].count().values
		N = class_counts.sum()
		print(class_counts)

		pi = (class_counts + alpha)/(N  + C*alpha)
		print(pi)
		
		def calc_thetac(x):
			Nc = x['class'].count()
			thetac = x.drop('class', axis=1).sum(axis=0)
			return (thetac + beta)/(Nc + 2*beta)

		theta = np.vstack(df.groupby('class').apply(calc_thetac).values).reshape((X.shape[1], C))
		del df

		self.pi = pi
		self.theta = theta

		self.logpi = np.log(self.pi + 1e-15)
		self.logtheta = np.log(self.theta + 1e-15)

		#print(self.pi)
		#print(self.theta)

		return pi, theta

	def predict(self, X):
		if self.pi.size == 0 or self.theta.size == 0:
			print("This model hasn't been fitted yet. Please call fit(X,y) before predicting.")
			return

		Xc = np.matmul(X,self.logtheta) + np.matmul(1-X, 1-self.logtheta)
		ypred = Xc + self.logpi
		lse = logsumexp(ypred, axis=1, keepdims=True)
		print(lse.shape)
		return np.exp(ypred - lse)