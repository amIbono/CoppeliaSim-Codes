mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create()                -- criando a rede MLP, se for somente usar a rede treinada, nao é necessario indicar o valor de learningRate
brain:addLayer(5)                       -- 1 layer: inputs, com 2 variaveis de entrada
brain:addLayer(10)                       -- 2 layer: hidden layer, com 2 variaveis
brain:addLayer(6)                       -- 3 layer: output layer, com 1 variavel de saida

brain:load("REDEMLPTANHsensor")             -- carrega a rede treinada

XOR_input = {{0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809}, -- floor
{0.11372549086809,0.0,0.11372549086809,0.11372549086809,0.11372549086809}, -- black
{0.39215686917305,0.11372549086809,0.11372549086809,0.11372549086809,1.0}, -- blue
{0.39215686917305,0.11372549086809,1.0,0.11372549086809,0.11372549086809}, -- red
{0.39215686917305,0.11372549086809,0.11372549086809,1.0,0.11372549086809}, -- green
{1.0,0.11372549086809,1.0,1.0,1.0}} -- white   -- input genérico

for i = 1,6 do
    valueFromAI = brain:forwardProp(XOR_input[i])
    --print('Input:',XOR_input[i][1],XOR_input[i][2],XOR_input[i][3],XOR_input[i][4],XOR_input[i][5])
    print('Result:',valueFromAI[1],valueFromAI[2],valueFromAI[3],valueFromAI[4],valueFromAI[5],valueFromAI[6])
end
