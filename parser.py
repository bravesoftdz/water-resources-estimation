import sys
import math 
from subBacia import SubBacia

def initialize(datafile='in.txt'):
	""" Função para ler o arquivo de entrada, parseá-lo e retornar as n sub-bacias lidas dele. """
	with open(datafile,'r') as f:
		nBacias = f.readline()
		#print("nbacias: ",nBacias)
		subBacias = [SubBacia() for i in range(int(nBacias))]
		content = f.read().splitlines()

	i = 0
	for line in content:
		valores = line.split()
		if(len(valores) >= 2):
			subBacias[i].area = float(valores[0])
			subBacias[i].cn = float(valores[1])
			subBacias[i].k = float(valores[2])
			subBacias[i].n = float(valores[3])
			subBacias[i].ia = float(valores[4])
			i+=1
		else:
			subBacias[i-1].leituras.append(float(line))
	return subBacias

def readObserved(datafile='Q_ESD_Observada.txt'):
	with open(datafile, 'r') as f:
		readings = f.read().splitlines()

	qEsd = []
	for line in readings:
		qEsd.append(float(line))

	return qEsd


