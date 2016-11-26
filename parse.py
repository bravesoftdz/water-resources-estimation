import sys

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
		self.leituras = []




with open('in.txt','r') as f:
	nBacias = f.readline()
	print("nbacias: ",nBacias)
	subBacias = [SubBacia() for i in range(int(nBacias))]
	content = f.read().splitlines()
	i = 0
	for line in content:
		valores = line.split()
		if(len(valores) >= 2):
			subBacias[i].area = float(valores[0])
			subBacias[i].cn = float(valores[1])
			subBacias[i].k = float(valores[2])
			subBacias[i].n = float(valores[3])
			i+=1
		else:
			subBacias[i-1].leituras.append(float(line))
		#print(i)
	i = 1
	for sb in subBacias:
		print("SubBacia "  + str(i) + "   area: " + str(sb.area) + "   cn: " + str(sb.cn) + "   k: " + str(sb.k) + "   n: " + str(sb.n))
		for l in sb.leituras:
			print(l)
		i+=1
