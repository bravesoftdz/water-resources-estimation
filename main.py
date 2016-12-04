from parser import initialize
from parser import readObserved
from subBacia import SubBacia

subBacias = initialize()

i = 1
for sb in subBacias:
	print("Sub-Bacia " + str(i))
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

qEsd = readObserved()

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

print(soma)
