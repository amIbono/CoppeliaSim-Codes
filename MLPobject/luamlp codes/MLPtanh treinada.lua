mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create()                -- criando a rede MLP, se for somente usar a rede treinada, nao é necessario indicar o valor de learningRate
brain:addLayer(2)                       -- 1 layer: inputs, com 2 variaveis de entrada
brain:addLayer(2)                       -- 2 layer: hidden layer, com 2 variaveis
brain:addLayer(1)                       -- 3 layer: output layer, com 1 variavel de saida

brain:load("REDEMLPTANH")             -- carrega a rede treinada

XOR_input = {{0,0},{1,1},{0,1},{1,0}}   -- input genérico

for i = 1,4 do
    valueFromAI = brain:forwardProp(XOR_input[i])
    print('Input:',XOR_input[i][1],XOR_input[i][2],'Result:',valueFromAI[1])
end

