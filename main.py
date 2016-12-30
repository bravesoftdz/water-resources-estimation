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

class setup_k_n(object):
	def __init__(self, subBacia, id):
		self.sb = subBacia
		
		self.params = []
		#self.tamanho_leituras = len(self.subBacias[0].leituras)

		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(id) +"]:k", 0, 300))
		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(id) +"]:n", 0, 10))
		

	def parameters(self):
		return spotpy.parameter.generate(self.params)

	def simulation(self,vector):
		simulations = [0.0]

		self.sb.calculaParte1(k = vector[0], n = vector[1])

		return [self.sb.verificacaoPe]
		

	def evaluation(self):
		observations = [1.0]

		return observations
	
	def objectivefunction(self, simulation = simulation, evaluation = evaluation):
		objectivefunction = -spotpy.objectivefunctions.rmse(evaluation = evaluation, simulation = simulation)
		return objectivefunction

class setup_cn(object):
	def __init__(self, subBacias, qEsd, k, n):
		self.subBacias = subBacias
		self.qEsd = qEsd
		self.params = []
		for i in range(len(self.subBacias)):
			self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) + "]:cn", 20, 99))
		self.k = k
		self.n = n

	def parameters(self):
		return spotpy.parameter.generate(self.params)

	def simulation(self,vector):
		
		i = 0
		for sb in self.subBacias:
			#print("Calculando parâmetro cn da Sub-Bacia " + str(i+1) + " k = " + str(self.k) + " n: " + str(self.n))
			sb.calcula(cn = vector[i], k = self.k, n = self.n)

			soma = [0.0 for x in range(len(sb.qSimulado))]
			j = 0
			for value in sb.qSimulado:
				soma[j] += value
				j+=1

			i+=1


		erro = [0.0 for x in range(len(soma))]
		while len(qEsd) < len(erro):
			qEsd.append(0.0)

		somatorioErro = 0.0
		j = 0
		while j < len(erro):
			erro[j] = math.pow(qEsd[j] - soma[j], 2)
			somatorioErro += erro[j]
			j+=1

		return [somatorioErro]
		

	def evaluation(self):
		observations = [0.0]
		return observations
	
	def objectivefunction(self, simulation = simulation, evaluation = evaluation):
		objectivefunction = -spotpy.objectivefunctions.rmse(evaluation = evaluation, simulation = simulation)
		return objectivefunction

rep = args['rep']
ngs = args['ngs']

subBacias = initialize()
qEsd = readObserved()

results=[]

best_parameters = []

for i in range(len(subBacias)):
	print("Calculando parâmetros k e n da Sub-Bacia " + str(i+1))
	setup = setup_k_n(subBacias[i], i)
	sampler = spotpy.algorithms.sceua(setup, dbname='saida', dbformat='ram')
	sampler.sample(rep,ngs=10, kstop = 100, peps = 1.0e-10)

	results.append(sampler.getdata())
	evaluation = setup.evaluation()

	best_parameters.append(spotpy.analyser.get_best_parameterset(sampler.getdata()))

print("best_parameters k n ")
params_k_n = []

for x in best_parameters:
	params_k_n.append(x[0])
	print(x[0])

best_parameters = []

for i in range(len(subBacias)):
	print("Calculando parâmetro cn das Sub-Bacias. Iteração " + str(i))
	params = params_k_n[i]
	setup = setup_cn(subBacias, qEsd, params[0], params[1])
	sampler = spotpy.algorithms.sceua(setup, dbname='saida', dbformat='ram')
	#sampler.sample(rep,ngs=5, kstop = 100, peps = 1.0e-10)
	sampler.sample(2000,ngs=5)
	results.append(sampler.getdata())
	evaluation = setup.evaluation()
	best_parameters.append(spotpy.analyser.get_best_parameterset(sampler.getdata()))

print("best_parameters cn ")
params = []
for x in best_parameters:
	print(x[0])
	params.append(x[0])

print("Calculando somatorioErro com os seguintes valores: ")
for i in range(len(subBacias)):
	#params = best_parameters[i]
	#params = params[0]
	cn = params[i][0]
	a = params_k_n[i]
	k = a[0]
	n = a[1]
	print("Sub-Bacia " + str(i+1) + " CN: " + str(cn) + " k: " + str(k) + " n: " + str(n))
	subBacias[i].calcula(cn, k, n)



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

#print(erro)
print("somatorioErro " + str(somatorioErro))

