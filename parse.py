import sys
import math 

dt = list(range(0, 3000, 30)) #0 a 3000, step = 30, representa a coluna A

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

class SubBacia:
	"""docstring for SubBacia
		Abaixo está o significado de cada váriavel utilizada pela classe e em seguida os métodos utilizados para
		os cálculos feitos na tabela excel recebida.
	"""
	def __init__(self):
		self.area = 0.0	# valor lido da entrada, area da sub-bacia, representa a coluna D
		self.cn = 0.0	# valor lido da entrada, parametro sendo estimado, representa a coluna M
		self.k = 0.0	# valor lido da entrada, parametro sendo estimado, representa a coluna B
		self.n = 0.0	# valor lido da entrada, parametro sendo estimado, representa a coluna C
		self.ia = 0.0	# valor lido da entrada, representa coluna K
		self.leituras = []	# valores lidos da entrada, leituras de precipitação em mm. representa a coluna J
		self.hui = list(dt) # lista com os valores calculados de HUI, representa as colunas E a H
		self.verificacaoPu = 0.0 # cálculo da "Verificação de Pu", representa a coluna I
		self.pacum = [] # lista que contém os valores de "Pacum", representa a coluna L
		self.s_mm = 0.0 # cálculo do valor s, representa a coluna N
		self.pefacum = [] # lista que contém os valores de "Pefacum", representa a coluna O
		self.pefIntervalo = [] # lista que contém os valores de "Pef intervalo", representa a coluna P
		self.qSimulado = [] # lista que contém os valores de "Q Simulado", representa a coluna BQ
							# Todas colunas de Q a BP, que são usadas para a soma armazenada em BQ
							# foram abstraídas com esta lista. Pois a mesma é inicializada com 0 em todas posições
							# e cada valor calculado é somado com o valor que já estava na posição para a qual ele foi designado
		self.verificaçãoPe = 0.0 # cálculo da "Verificação de Pe", representa a coluna BR
		self.qp = 0.0		# variável que contém o maior valor verificado em qSimulado, calculado no mesmo método de "Verificação de Pe"
							# e representa a coluna BT

	def show(self):
		print("Área: " + str(self.area) + "   cn: " + str(self.cn) + "   k: " + str(self.k) + "   n: " + str(self.n) + "   Ia: " + str(self.ia))
		for l in sb.leituras:
			print(l)

	def calculaSmm(self):
		self.s_mm = (float(25400)/self.cn) - 254

	def calculaHUI(self):
		i = 0
		tempHui = list(dt)
		for value in self.hui:
			#Coluna E
			self.hui[i] = (1/(self.k*math.gamma(self.n)))*math.exp(-dt[i]/self.k)*math.pow((dt[i]/self.k),(self.n-1))

			#Coluna F
			# 10000000/60000 = 1000/6
			self.hui[i] = float(1000/6) * self.area * self.hui[i]

			#Coluna G
			if i == 0:
				tempHui[i] = float(self.hui[i] / 2)				
			else:
				tempHui[i] = float((self.hui[i-1] + self.hui[i]) / float(2))
				
			#Coluna H
			tempHui[i] = float(tempHui[i] / float(10))
			i+=1

		self.hui = tempHui
		tempHui = []

	def calculaVerificacaoPu(self):
		#Verificação de Pu = 1mm   ↑
		#=(SOMA(H3:H132)*30*60)/(D3*1000)
		#				 1800
		soma = 0.0
		for value in self.hui:
			soma += value
		self.verificacaoPu = float(soma * 1800) / float(self.area * 1000)

	def calculaPAcum(self):
		self.pacum.append(self.ia)
		l = len(self.leituras)
		i = 1
		while i < l:
			#lista[-1] retorna ultimo elemento da lista
			self.pacum.append(self.pacum[-1] + self.leituras[i])	
			i+=1

	def calculaPefacum(self):
		for value in self.pacum:
			self.pefacum.append( math.pow((value - self.ia), 2) / (value + self.s_mm - self.ia) )

	def calculaPefIntervalo(self):
		self.pefIntervalo.append(0.0)
		l = len(self.pefacum)
		i = 1
		while i < l: 
			self.pefIntervalo.append(self.pefacum[i] - self.pefacum[i-1])
			i+=1

	def calculaQSimulado(self):
		pefIntervaloLenght = len(self.pefIntervalo)
		huiLenght = len(self.hui)
		self.qSimulado = [0.0 for x in range(huiLenght)]
		
		i = 0
		for pefIntervalo in self.pefIntervalo:
			k = i
			for hui in self.hui:
				self.qSimulado[k] += (pefIntervalo / self.verificacaoPu) * hui 
				k+=1
			i+=1
			self.qSimulado.append(0.0)
		
	def calculaVerificacaoPe(self):
		soma = 0.0
		self.qp = -1
		for value in self.qSimulado:
			soma += value
			if value > self.qp:
				self.qp = value
		self.verificaçãoPe = (soma*1800) / (self.area*1000)

	def calcula(self):
		self.calculaHUI()
		self.calculaVerificacaoPu()
		self.calculaPAcum()
		self.calculaSmm()
		self.calculaPefacum()
		self.calculaPefIntervalo()
		self.calculaQSimulado()
		self.calculaVerificacaoPe()



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
	print(sb.verificaçãoPe)
	i+=1



