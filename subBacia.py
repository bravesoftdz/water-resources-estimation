import math
class SubBacia(object):
	dt = list(range(0, 3000, 30)) #0 a 3000, step = 30, representa a coluna A
	"""docstring for SubBacia
		Classe que representa uma sub-bacia, com todas as variáveis utilizada na planilha excel recebida.
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
		self.hui = list(SubBacia.dt) # lista com os valores calculados de HUI, representa as colunas E a H
		self.verificacaoPu = 0.0 # cálculo da "Verificação de Pu", representa a coluna I
		self.pacum = [] # lista que contém os valores de "Pacum", representa a coluna L
		self.s_mm = 0.0 # cálculo do valor s, representa a coluna N
		self.pefacum = [] # lista que contém os valores de "Pefacum", representa a coluna O
		self.pefIntervalo = [] # lista que contém os valores de "Pef intervalo", representa a coluna P
		self.qSimulado = [] # lista que contém os valores de "Q Simulado", representa a coluna BQ
							# Todas colunas de Q a BP, que são usadas para a soma armazenada em BQ
							# foram abstraídas com esta lista. Pois a mesma é inicializada com 0 em todas posições
							# e cada valor calculado é somado com o valor que já estava na posição para a qual ele foi designado
		self.verificacaoPe = 0.0 # cálculo da "Verificação de Pe", representa a coluna BR
		self.qp = 0.0		# variável que contém o maior valor verificado em qSimulado, calculado no mesmo método de "Verificação de Pe"
							# e representa a coluna BT
		self.flagRodouPAcum = False
		self.flagRodouPefacum = False
		self.flagRodouPefIntervalo = False
		self.flagRodouQSimulado = False

	def show(self):
		print("Área: " + str(self.area) + "   cn: " + str(self.cn) + "   k: " + str(self.k) + "   n: " + str(self.n) + "   Ia: " + str(self.ia))
		for l in sb.leituras:
			print(l)

	def calculaSmm(self):
		self.s_mm = (float(25400)/self.cn) - 254

	def calculaHUI(self):
		i = 0
		tempHui = list(SubBacia.dt)
		for value in self.hui:
			#Coluna E
			self.hui[i] = (1/(self.k*math.gamma(self.n)))*math.exp(-SubBacia.dt[i]/self.k)*math.pow((SubBacia.dt[i]/self.k),(self.n-1))

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
		if not self.flagRodouPAcum: #se nao rodou pela primeira vez
			self.pacum.append(self.ia)
			l = len(self.leituras)
			i = 1
			while i < l:
				#lista[-1] retorna ultimo elemento da lista
				self.pacum.append(self.pacum[-1] + self.leituras[i])	
				i+=1
			#print("pacum" + str(len(self.pacum)))
			self.flagRodouPAcum = True
		else:
			i = 1
			l = len(self.leituras)
			while i < l:
				self.pacum[i] = self.pacum[i-1] + self.leituras[i]
				i+=1
			#print("pacum" + str(len(self.pacum)))


	def calculaPefacum(self):
		if not self.flagRodouPefacum:
			for value in self.pacum:
				self.pefacum.append( math.pow((value - self.ia), 2) / (value + self.s_mm - self.ia) )
			#print("pefacum" + str(len(self.pefacum)))
			self.flagRodouPefacum = True
		else:
			i = 0
			l = len(self.pacum)
			while i < l:
				self.pefacum[i] = math.pow((self.pacum[i] - self.ia), 2) / (self.pacum[i] + self.s_mm - self.ia)
				i+=1
			#print("pefacum" + str(len(self.pefacum)))

	def calculaPefIntervalo(self):
		if not self.flagRodouPefIntervalo:
			self.pefIntervalo.append(0.0)
			l = len(self.pefacum)
			i = 1
			while i < l: 
				self.pefIntervalo.append(self.pefacum[i] - self.pefacum[i-1])
				i+=1
			#print("pefIntervalo" + str(len(self.pefIntervalo)))
			self.flagRodouPefIntervalo = True
		else:
			l = len(self.pefacum)
			i = 1
			while i < l:
				self.pefIntervalo[i] = self.pefacum[i] - self.pefacum[i-1]
				i+=1
			#print("pefIntervalo" + str(len(self.pefIntervalo)))


	def calculaQSimulado(self):
		huiLenght = len(self.hui)
		self.qSimulado = [0.0 for x in range(huiLenght)]
		
		if self.verificacaoPu == 0.0:
			self.verificacaoPu += 1.0e-100

		i = 0
		for pefIntervalo in self.pefIntervalo:
			k = i
			for hui in self.hui:
				self.qSimulado[k] += (pefIntervalo / self.verificacaoPu) * hui 
				k+=1
			i+=1
			self.qSimulado.append(0.0)

		#print("qSimulado" + str(len(self.qSimulado)))
		
	def calculaVerificacaoPe(self):
		soma = 0.0
		self.qp = -1
		for value in self.qSimulado:
			soma += value
			if value > self.qp:
				self.qp = value
		self.verificacaoPe = (soma*1800) / (self.area*1000)
	"""
	Removido para usar com a lib
	"
	def calcula(self):
		self.calculaHUI()
		self.calculaVerificacaoPu()
		self.calculaPAcum()
		self.calculaSmm()
		self.calculaPefacum()
		self.calculaPefIntervalo()
		self.calculaQSimulado()
		self.calculaVerificacaoPe()
	"""

	"""
	Métodos para tentar usar a lib, ou seja, passando k, n e CN por parametro
	"""
	def calculaSmm(self, cn):
		self.s_mm = (float(25400)/cn) - 254

	def calculaHUI(self, k, n):
		i = 0
		tempHui = list(SubBacia.dt)
		for value in self.hui:
			#Coluna E
			if SubBacia.dt[i] == 0.0: # pow(0.0, -n) = math domain error 
				#SubBacia.dt[i] += 0.000000000000000000000000000000000000000000000000001
				SubBacia.dt[i] += 1.0e-100
			#a = (SubBacia.dt[i]/k)
			#b = (n-1)
			#print("dt: " + str(SubBacia.dt[i]))
			#print("a:" + str(a) )
			#print("b: " + str(b) )
			#print("pow: " + str(math.pow(a,b)))
			self.hui[i] = (1/(k*math.gamma(n)))*math.exp(-SubBacia.dt[i]/k)*math.pow((SubBacia.dt[i]/k),(n-1))

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


	def calcula(self, cn=None, k=None, n=None):
		if not cn is None and not k is None and not n is None:
			self.calculaHUI(k, n)
			self.calculaVerificacaoPu()
			self.calculaPAcum()
			self.calculaSmm(cn)
			self.calculaPefacum()
			self.calculaPefIntervalo()
			self.calculaQSimulado()
			self.calculaVerificacaoPe()
		else:
			self.calculaHUI(self.k, self.n)
			self.calculaVerificacaoPu()
			self.calculaPAcum()
			self.calculaSmm(self.cn)
			self.calculaPefacum()
			self.calculaPefIntervalo()
			self.calculaQSimulado()
			self.calculaVerificacaoPe()
	"""
	"""