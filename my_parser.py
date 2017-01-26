from subBacia import SubBacia

def initialize(datafile='in.txt'):
	""" Função para ler o arquivo de entrada, parseá-lo e retornar as n sub-bacias lidas dele. """
	with open(datafile,'r') as f:
		nBacias = f.readline()
		nBacias = int(nBacias)
		#print("nbacias: ",nBacias)
		subBacias = [SubBacia() for i in range(nBacias)]
		content = f.read().splitlines()

	i = 0
	for sb in subBacias:
		#print(content[i])
		line = content[i]
		valores = line.split()
		
		sb.area = float(valores[0])
		sb.cn = float(valores[1])
		sb.k = float(valores[2])
		sb.n = float(valores[3])
		sb.ia = float(valores[4])
		
		i+=1
		line = content[i]
		valores = line.split()

		while(len(valores) < 2):
			sb.leituras.append(float(line))
			i+=1
			if i < len(content):
				line = content[i]
				valores = line.split()
			else:
				break

	return subBacias

def readObserved(datafile='Q_ESD_Observada.txt'):
	with open(datafile, 'r') as f:
		readings = f.read().splitlines()

	qEsd = []
	for line in readings:
		qEsd.append(float(line))

	return qEsd


