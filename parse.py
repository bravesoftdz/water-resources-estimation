import sys
import math 

dt = list(range(0, 3000, 30)) #0 a 3000, step = 30

class SubBacia:
	"""docstring for SubBacia"""
	def __init__(self):
		self.area = 0.0
		self.cn = 0.0
		self.k = 0.0
		self.n = 0.0
		self.ia = 0.0
		self.leituras = []
		self.hui = list(dt)

	def show(self):
		print("Área: " + str(self.area) + "   cn: " + str(self.cn) + "   k: " + str(self.k) + "   n: " + str(self.n) + "   Ia: " + str(self.ia))
		for l in sb.leituras:
			print(l)

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



with open('in.txt','r') as f:
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
		
i = 1
for sb in subBacias:
	print("SubBacia " + str(i))
	sb.show()
	sb.calculaHUI()
	print(sb.hui)
	i+=1



