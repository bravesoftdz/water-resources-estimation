# water-resources-estimation
<p> Para a execução é necessário ter instalado o Python 3.5.2 (python3) e a biblioteca <a href="http://fb09-pasig.umwelt.uni-giessen.de/spotpy/">Spotpy</a>, sendo que ela precisa da NumPy e da Scipy, segundo a documentação. </p>
<p> Com elas instaladas, basta chamar o arquivo <a href="https://github.com/erickm32/water-resources-estimation/blob/master/main.py">main.py </a> passando os parâmetros ngs e número de repetições. No exemplo abaixo, 28 e 5000, respectivamente. </p>
<p> $ python3 main.py --ngs=28 --rep=5000 </p> 
<p> Também é necessário ter os arquivos in.txt e Q_ESD_Observada.txt (além dos outros .py) na pasta. </p> 
<p> <strike> Pro Windows deve ser só clicar pra executar o main.py. </strike> </p>
<p> Ainda não consegui testar efetivamente no Windows para dar instruções precisas de como executar.</p>
<p></p>
<p> A codificação de in.txt é: </p> 
<ul>
  <li> 'Número de sub-bacias' </li> 
  <li> 'Área da sub-bacia' 'CN' 'k(min)' 'n' 'Ia' (que acredito ser o valor de leitura inicial, era a coluna K) </li> 
  <li> Todas leituras de precipitações(mm) uma abaixo da outra, com ponto ao invés de vírgula para "números com vírgula", repetindo 'Número de sub-bacias' vezes. </li> 
</ul>
<p> A codificação de Q_ESD_Observada.txt é: </p> 
<ul>
  <li> Apenas todas as leituras Q ESD Observadas, todos os valores da coluna J da tabela de Controle, um abaixo do outro, também com ponto ao invés de virgula.</li>
</ul>

