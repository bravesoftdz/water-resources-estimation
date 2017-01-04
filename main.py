import math
import spotpy
import numpy as np
import sys, argparse
from parser import initialize
from parser import readObserved
from subBacia import SubBacia

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--ngs', type=int, required=True)
    parser.add_argument('--rep', type=int, required=True)
    args = parser.parse_args()
    args = vars(args)
    # ... do something with args.output ...
    # ... do something with args.verbose ..

class spot_setup(object):
	def __init__(self):
		self.subBacias = initialize()
		self.qEsd = readObserved()
		self.params = []
		self.tamanho_leituras = len(self.subBacias[0].leituras)
		#print("entrou em init: " + str(self.tamanho_leituras))

		i = 0
		for sb in self.subBacias:
			self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:cn", 20, 99))
			self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:k", 0, 300))
			self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:n", 0, 10))
			i+=1

	def parameters(self):
		#print("entrou em parameters")
		return spotpy.parameter.generate(self.params)

	def simulation(self,vector):
		#simulations= [0.0 for x in range()]
		#print("entrou em simulation")
		qEsd = self.qEsd

		i = 0
		for sb in self.subBacias:
			sb.calculaTudo(cn = vector[i], k = vector[i+1], n = vector[i+2])
			#qSimulado é (deve ser) a lista que contém todos os ultimos valores calculados
			#eles que serão somados com os das outras sub-bacias pra calcular a planilha de controle

			soma = [0.0 for x in range(len(sb.qSimulado))]
			j = 0
			for value in sb.qSimulado:
				soma[j] += value
				j+=1

			i+=3


		erro = [0.0 for x in range(len(soma))]
		while len(qEsd) < len(erro):
			qEsd.append(0.0)

		#print("len(erro): " + str(len(erro)) + " len soma: " + str(len(soma)) + " len qEsd" + str(len(self.qEsd))  )
		somatorioErro = 0.0
		j = 0
		while j < len(erro):
			erro[j] = math.pow(qEsd[j] - soma[j], 2)
			somatorioErro += erro[j]
			j+=1

		#return simulations
		#print("len erro" + str(len(erro)))
		#return erro
		return [somatorioErro]

	def evaluation(self):
		#observations = [0.0 for x in range(len(SubBacia.dt) + self.tamanho_leituras )]
		observations = [0]

		#print("entrou em evaluation: " + str(len(observations)))
		return observations
	
	def objectivefunction(self, simulation = simulation, evaluation = evaluation):
		print("entrou em objectivefunction1")
		objectivefunction = -spotpy.objectivefunctions.rmse(evaluation = evaluation, simulation = simulation)      
		print("entrou em objectivefunction2")
		return objectivefunction

def calculaSomatorioErro(subBacias, qEsd, best_parameters):
	i = 1
	j = 0
	for sb in subBacias:
		cn = best_parameters[j]
		k = best_parameters[j+1]
		n = best_parameters[j+2]
		print("Sub-Bacia " + str(i) + " CN: " + str(cn) + " k: " + str(k) + " n: " + str(n))
		sb.calculaTudo(cn, k, n)
		i+=1
		j+=3

	qSimuladoLength = len(subBacias[0].qSimulado)
	# Todas sub-bacias possuem o mesmo tamanho de qSimulado,
	# ao menos estou assumindo isso

	while len(qEsd) < qSimuladoLength:
		qEsd.append(0.0)

	soma = [0.0 for x in range(qSimuladoLength)]

	for sb in subBacias:
		i = 0
		for value in sb.qSimulado:
			soma[i] += value
			i+=1

	erro = [0.0 for x in range(qSimuladoLength)]
	somatorioErro = 0.0
	i = 0
	while i < qSimuladoLength:
		erro[i] = math.pow(qEsd[i] - soma[i], 2)
		somatorioErro += erro[i]
		i+=1

	return somatorioErro


rep = args['rep']
ngs = args['ngs']

#Create samplers for every algorithm:
results=[]
setup=spot_setup()
#rep=10000
#ngs=28

vezes = 10
while(True): # do-while fulero
	sampler=spotpy.algorithms.sceua(setup, dbname='saida', dbformat='ram')
	sampler.sample(rep,ngs=ngs)

	#results.append(sampler.getdata())
	#evaluation = setup.evaluation()
	#spotpy.analyser.plot_parameterInteraction(results) 

	best_parameters = spotpy.analyser.get_best_parameterset(sampler.getdata())
	print(best_parameters)

	#subBacias = setup.subBacias
	#qEsd = setup.qEsd

	#best_parameters = best_parameters[0]

	somatorioErro = calculaSomatorioErro(setup.subBacias, setup.qEsd, best_parameters[0])
	vezes-=1
	#print(erro)
	print("Somatorio Erro: " + str(somatorioErro))
	if somatorioErro < 100.00 or vezes < 0:
		break


