import sys
import math 
from subBacia import SubBacia


def initialize(datafile='in.txt'):
	""" Função para ler o arquivo de entrada, parseá-lo e retornar as n sub-bacias lidas dele. """
	with open(datafile,'r') as f:
		nBacias = f.readline()
		print("nbacias: ",nBacias)
		subBacias = [SubBacia() for i in range(int(nBacias))]
		content = f.read().splitlines()

	i = 0
	novaBacia = False
	for line in content:
		valores = line.split()
		if(len(valores) >= 2):
			subBacias[i].area = float(valores[0])
			subBacias[i].cn = float(valores[1])
			subBacias[i].k = float(valores[2])
			subBacias[i].n = float(valores[3])
			i+=1
			novaBacia = False
		else:
			if not novaBacia:
				subBacias[i-1].ia = float(line)
				novaBacia = True
			else:
				subBacias[i-1].leituras.append(float(line))
	return subBacias


subBacias = initialize()

i = 1
for sb in subBacias:
	print("SubBacia " + str(i))
	#sb.show()
	sb.calcula()
	#print(sb.hui)
	#print("sb.verificacaoPu: " + str(sb.verificacaoPu))
	#print(sb.pacum)
	#print(sb.pefacum)
	#print(sb.pefIntervalo)
	#print(sb.bq)
	#print(sb.verificaçãoPe)
	i+=1



