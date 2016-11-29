import sys
import math 

dt = list(range(0, 3000, 30)) #0 a 3000, step = 30

def initialize(datafile='in.txt'):
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
	"""docstring for SubBacia"""
	def __init__(self):
		self.area = 0.0
		self.cn = 0.0
		self.k = 0.0
		self.s_mm = 0.0 # coluna N
		self.n = 0.0
		self.ia = 0.0
		self.leituras = []	#aka precipitação mm
		self.hui = list(dt)
		self.verificacaoPu = 0.0
		self.pacum = []
		self.pefacum = []

	def show(self):
		print("Área: " + str(self.area) + "   cn: " + str(self.cn) + "   k: " + str(self.k) + "   n: " + str(self.n) + "   Ia: " + str(self.ia))
		for l in sb.leituras:
			print(l)

	def calculaSmm(self):
		self.s_mm = (float(25400)/self.cn) - 254
		#print("s_mm: " + str(self.s_mm) + " cn: " + str(self.cn) + " div: " + str(float(25400)/self.cn))

	def calculaHUI(self):
		i = 0
		tempHui = list(dt)
		for value in self.hui:
			#Coluna E
			self.hui[i] = (1/(self.k*math.exp(math.lgamma(self.n))))*math.exp(-dt[i]/self.k)*math.pow((dt[i]/self.k),(self.n-1))

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
		#				 180
		soma = 0.0
		for value in self.hui:
			soma += value
		self.verificacaoPu = (soma * 180) / (self.area * 1000)

	def calculaPAcum(self):
		self.pacum.append(self.ia)

		""" está certo este cálculo??"""
		l = len(self.leituras)
		i = 1
		for value in range(l):
			try:
				#print("temp: " + str(temp) + " lastPacum: " + str(self.pacum[-1]) + " leituras[i]: " + str(self.leituras[i]))
				self.pacum.append(self.pacum[-1] + self.leituras[i])	#lista[-1] retorna ultimo elemento da lista
				i+=1
			except Exception:
				pass

	def calculaPefacum(self):
		for value in self.pacum:
			#print("value: " + str(value) + " s_mm: " + str(self.s_mm) + " ia: " + str(self.ia))
			self.pefacum.append( math.pow((value - self.ia), 2) / (value + self.s_mm - self.ia) )



	def calcula(self):
		self.calculaHUI()
		self.calculaVerificacaoPu()
		self.calculaPAcum()
		self.calculaSmm()
		self.calculaPefacum()





	
# Mudar tamanho das listas de hui para o tamanho da entrada lida para cada bacia e tal

subBacias = initialize()

i = 1
for sb in subBacias:
	print("SubBacia " + str(i))
	#sb.show()
	sb.calcula()
	#print(sb.hui)
	#print("sb.verificacaoPu: " + str(sb.verificacaoPu))
	#print(sb.pacum)
	print(sb.pefacum)
	i+=1



