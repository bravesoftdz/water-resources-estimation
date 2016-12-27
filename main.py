import math
import spotpy
import numpy as np
from parser import initialize
from parser import readObserved
from subBacia import SubBacia

class spot_setup(object):
	def __init__(self):
		self.subBacias = initialize()
		self.qEsd = readObserved()
		self.params = []
		#self.tamanho_leituras = len(self.subBacias[0].leituras)
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
			sb.calcula(cn = vector[i], k = vector[i+1], n = vector[i+2])
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

#Create samplers for every algorithm:
results=[]
setup=spot_setup()
rep=20000
sampler=spotpy.algorithms.sceua(setup, dbname='saida', dbformat='ram')
sampler.sample(rep,ngs=28)
"""
class sceua(_algorithm)  def sample(self, repetitions, ngs=20, kstop=100, pcento=0.0000001, peps=0.0000001) Inferred type: (self: sceua, repetitions: int, ngs: int, kstop: int, pcento: int, peps: float) -> None  
Samples from parameter distributions using SCE-UA (Duan, 2004), converted to python by Van Hoey (2011).
  
repetitions:
(int) maximum number of function evaluations allowed during optimization
ngs:
(int) number of complexes (sub-populations), take more then the number of analysed parameters
kstop:
(int) maximum number of evolution loops before convergency
pcento:
(int) the percentage change allowed in kstop loops before convergency
peps:
(float) Convergence criterium
"""
results.append(sampler.getdata())
evaluation = setup.evaluation()

best_parameters = spotpy.analyser.get_best_parameterset(sampler.getdata())
print(best_parameters)
#subBacias = initialize()
subBacias = setup.subBacias

best_parameters = best_parameters[0]
i = 1
j = 0
for sb in subBacias:
	cn = best_parameters[j]
	k = best_parameters[j+1]
	n = best_parameters[j+2]
	print("Sub-Bacia " + str(i) + " CN: " + str(cn) + " k: " + str(k) + " n: " + str(n))
	sb.calcula(cn, k, n)
	i+=1
	j+=3

qEsd = setup.qEsd

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
print(somatorioErro)


