import sys

class SubBacia:
	"""docstring for SubBacia"""
	def __init__(self, arg):
		super(SubBacia, self).__init__()
		self.arg = arg


sub_bacia = [[],[]]

with open('in.txt','r') as f:
	nBacias = f.readline()
	print("nbacias: ",nBacias)
	content = f.read().splitlines()
	for line in content:
		valores = line.split()
		if(len(valores) >= 2):
			print(line)