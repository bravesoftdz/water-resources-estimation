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

    	i = 0 
    	for sb in self.subBacias:
    		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:cn", 20, 99))
    		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:k", 0, 300))
    		self.params.append(spotpy.parameter.Uniform("subBacia[" + str(i) +"]:n", 0, 10))
    		i+=1

    def parameters(self):
    	print("entrou em parameters")
    	return spotpy.parameter.generate(self.params)
        
    def simulation(self,vector):      
        simulations= [0.0 for x in range()]

        i = 0
        for sb in self.subBacias:
        	sb.calcula(cn = vector[i], k = vector[i+1], n = vector[i+2])
        	#qSimulado é (deve ser) a lista que contém todos os ultimos valores calculados
        	#eles que serão somados com os das outras sub-bacias pra calcular a planilha de controle
        	soma = [0.0 for x in range(qSimuladoLength)]

			for sb in subBacias:
				i = 0
				for value in sb.qSimulado:
					soma[i] += value
					i+=1


        	simulations.append(sb.qSimulado)
        	i+=3


        #print("entrou em simulation " + str(vector) + " K: " + str(vector[2]) )
        return simulations
        
    def evaluation(self):
        observations = [0]
        print("entrou em evaluation")
        return observations
    
    def objectivefunction(self, simulation = simulation, evaluation = evaluation):
        objectivefunction = -spotpy.objectivefunctions.rmse(evaluation = evaluation, simulation = simulation)      
        print("entrou em objectivefunction")
        return objectivefunction

#Create samplers for every algorithm:
results=[]
setup=spot_setup()
rep=5000
sampler=spotpy.algorithms.sceua(setup, dbname='saida', dbformat='csv')
sampler.sample(rep,ngs=4)
results.append(sampler.getdata())
evaluation = setup.evaluation()        

#subBacias = initialize()
subBacias = setup.subBacias

i = 1
for sb in subBacias:
	print("Sub-Bacia " + str(i))
	sb.calcula()
	i+=1

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

print(erro)
print(somatorioErro)


