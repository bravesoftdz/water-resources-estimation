import math
import spotpy
import numpy as np
from parser import initialize
from parser import readObserved
from subBacia import SubBacia

class spot_setup(object):
	def __init__(self, subBacia, id):
		self.sb = subBacia
		
		self.params = []

		
		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(id) +"]:cn", 20, 99))
		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(id) +"]:k", 0, 50))
		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(id) +"]:n", 0, 31))
		

	def parameters(self):
		#print("entrou em parameters")
		return spotpy.parameter.generate(self.params)

	def simulation(self,vector):
		#simulations= [0.0 for x in range()]
		#print("entrou em simulation")
		
		simulations = [0.0]

		self.sb.calcula(cn = vector[0], k = vector[1], n = vector[2])
		#qSimulado é (deve ser) a lista que contém todos os ultimos valores calculados
		#eles que serão somados com os das outras sub-bacias pra calcular a planilha de controle

		simulations[0] = self.sb.verificacaoPe

		return simulations

	def evaluation(self):
		#observations = [0.0 for x in range(len(SubBacia.dt) + self.tamanho_leituras )]
		observations = [1.0]

		#print("entrou em evaluation: " + str(len(observations)))
		return observations
	
	def objectivefunction(self, simulation = simulation, evaluation = evaluation):
		print("entrou em objectivefunction1")
		objectivefunction = -spotpy.objectivefunctions.rmse(evaluation = evaluation, simulation = simulation)      
		print("entrou em objectivefunction2")
		return objectivefunction


subBacias = initialize()
qEsd = readObserved()


results=[]
rep=50000

best_parameters = []

for i in range(len(subBacias)):
	print("Calculando parâmetros da Sub-Bacia " + str(i+1))
	setup=spot_setup(subBacias[i], i)
	sampler=spotpy.algorithms.sceua(setup, dbname='saida', dbformat='ram')
	sampler.sample(rep,ngs=3, kstop = 50)

	results.append(sampler.getdata())
	evaluation = setup.evaluation()

	best_parameters.append(spotpy.analyser.get_best_parameterset(sampler.getdata()))

#best_parameters = spotpy.analyser.get_best_parameterset(sampler.getdata())
#print(best_parameters)
'''
#subBacias = initialize()
subBacias = setup.subBacias
'''
#best_parameters = best_parameters[0]

for i in range(len(subBacias)):
	params = best_parameters[i]
	params = params[0]
	cn = params[0]
	k = params[1]
	n = params[2]
	print("Sub-Bacia " + str(i+1) + " CN: " + str(cn) + " k: " + str(k) + " n: " + str(n))
	subBacias[i].calcula(cn, k, n)
	print("verificacaoPe: " + str(subBacias[i].verificacaoPe) )


'''
qEsd = setup.qEsd
'''
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

