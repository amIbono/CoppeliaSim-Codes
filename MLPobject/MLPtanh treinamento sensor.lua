mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create(0.03)                -- criando a rede MLP com learnig rate de 0.03
brain:addLayer(5)                       -- 1 layer: inputs, com 2 variaveis de entrada
brain:addLayer(10)                       -- 2 layer: hidden layer, com 2 variaveis
brain:addLayer(6)                       -- 3 layer: output layer, com 1 variavel de saida

brain:setMomentum(0.001)                -- momentum de 0.001, já que valores maiores tendem a não se aproximar do resultado esperado
errorCoeficient = 0.001                  -- coeficiente de erro, utilizado para a rotina de treinamento, finaliza a rotina caso o erro seja menor que o posto.
RMSE = 1                                -- valor de erro quadrático, utilizado para a rotina de treinamento, se ajusta conforme o erro encontrado pela funçao
interations = 1000000                   -- numero de interações máximo

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

error = 0.05

XOR_input = {{0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809}, -- floor
{0.11372549086809,0.0,0.11372549086809,0.11372549086809,0.11372549086809}, -- black
{0.39215686917305,0.11372549086809,0.11372549086809,0.11372549086809,1.0}, -- blue
{0.39215686917305,0.11372549086809,1.0,0.11372549086809,0.11372549086809}, -- red
{0.39215686917305,0.11372549086809,0.11372549086809,1.0,0.11372549086809}, -- green
{1.0,0.11372549086809,1.0,1.0,1.0}} -- white   -- input e output, usados para treinamento da rede
XOR_output = {{1,0,0,0,0,0},{0,1,0,0,0,0},{0,0,1,0,0,0},{0,0,0,1,0,0},{0,0,0,0,1,0},{0,0,0,0,0,1}} -- floor, black, blue, red, green, white

--brain:transfer(0) 
--brain:randomizeWeights()

for _ = 1,interations do                -- rotina de treinamento, onde sao feitas n interações, encontrado o valor na funçao pelo propagation, e reajustado os pesos no backpropagation.
                                        -- O valor de erro quadrático encontrado com o resultado esperado é avaliado com o erro minimo posto, assim finalizando a rotina de treinamento.
    if RMSE < errorCoeficient then
        break
    else
        for i = 1,6 do
            valueFromAI = brain:forwardProp(XOR_input[i])
            brain:backwardProp(XOR_output[i])
            RMSE = brain:getRMSE(XOR_output[i])
            --print('Input:',XOR_input[i][1],XOR_input[i][2],'\nResult:',valueFromAI[1],valueFromAI[2],valueFromAI[3],valueFromAI[4],valueFromAI[5],valueFromAI[6],'\nError:',brain:getRMSE(XOR_output[i]))
            brain:saveWeights() -- pesos salvados após interaçao da rotina de treinamento
        end
    end
end

brain:loadWeights() -- pesos carregados para uso.

brain:save("REDEMLPTANHsensor") -- forma de salvar os valores, pesos, bias, da rede e poder utilizar pós treinamento.