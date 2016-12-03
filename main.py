from parser import initialize

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

soma = [0.0 for x in range(len(subBacias[0].qSimulado))]
i = 0
for sb in subBacias:
	soma[i] += sb.qSimulado[i]
	i+=1

print(soma)
