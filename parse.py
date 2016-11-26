import sys

dt = list(range(0, 3000, 30)) #0 a 3000, step = 30

class SubBacia:
	"""docstring for SubBacia"""
	#def __init__(self, area, cn, k, n):
		#self.area = area
		#self.cn = cn
		#self.k = k
		#self.n = n
		#self.leituras = []
	def __init__(self):
		self.area = 0.0
		self.cn = 0.0
		self.k = 0.0
		self.n = 0.0
		self.ia = 0.0
		self.leituras = []

	def print(self):
		print("Área: " + str(self.area) + "   cn: " + str(self.cn) + "   k: " + str(self.k) + "   n: " + str(self.n) + "   Ia: " + str(self.ia))
		for l in sb.leituras:
			print(l)




with open('in.txt','r') as f:
	nBacias = f.readline()
	print("nbacias: ",nBacias)
	subBacias = [SubBacia() for i in range(int(nBacias))]
	content = f.read().splitlines()

i = 0
leuIa = False
for line in content:
	valores = line.split()
	if(len(valores) >= 2):
		subBacias[i].area = float(valores[0])
		subBacias[i].cn = float(valores[1])
		subBacias[i].k = float(valores[2])
		subBacias[i].n = float(valores[3])
		i+=1
		leuIa = False
	else:
		if not leuIa:
			subBacias[i-1].ia = float(line)
			leuIa = True
		else:
			subBacias[i-1].leituras.append(float(line))
		
i = 1
for sb in subBacias:
	print("SubBacia " + str(i))
	sb.print()
	i+=1
