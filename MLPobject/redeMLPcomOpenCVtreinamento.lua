mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create(0.03)                -- criando a rede MLP com learnig rate de 0.03
brain:addLayer(1)                       -- 1 layer: inputs, com 1 variaveis de entrada
brain:addLayer(10)                       -- 2 layer: hidden layer, com 10 variaveis
brain:addLayer(6)                       -- 3 layer: output layer, com 1 variavel de saida

brain:setMomentum(0.001)                -- momentum de 0.001, já que valores maiores tendem a não se aproximar do resultado esperado
errorCoeficient = 0.001                  -- coeficiente de erro, utilizado para a rotina de treinamento, finaliza a rotina caso o erro seja menor que o posto.
RMSE = 1                                -- valor de erro quadrático, utilizado para a rotina de treinamento, se ajusta conforme o erro encontrado pela funçao
interations = 10000                   -- numero de interações máximo

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

error = 0.1
floor = {0,29,0} ; white = {0,255,0} ; green = {59,144,255}
red = {118,142,255} ; blue = {0,139,255} ; black = {0,23,0}

XOR_output = {{1,0,0,0,0,0},{0,1,0,0,0,0},{0,0,1,0,0,0},{0,0,0,1,0,0},{0,0,0,0,1,0},{0,0,0,0,0,1}} -- floor, black, blue, red, green, white
--brain:transfer(0) 
--brain:randomizeWeights()

for _ = 1,interations do                -- rotina de treinamento, onde sao feitas n interações, encontrado o valor na funçao pelo propagation, e reajustado os pesos no backpropagation.
                                        -- O valor de erro quadrático encontrado com o resultado esperado é avaliado com o erro minimo posto, assim finalizando a rotina de treinamento.
    if RMSE < errorCoeficient then
        break
    else
        for i = 1,6 do
            XOR_input = {floor, -- floor
                        black, -- black
                        blue, -- blue
                        red, -- red
                        green, -- green
                        white} -- white   -- input e output, usados para treinamento da rede
            print(XOR_input[i])
            valueFromAI = brain:forwardProp(XOR_input[i])
            brain:backwardProp(XOR_output[i])
            RMSE = brain:getRMSE(XOR_output[i])
            print('Input:',XOR_input[i][1],XOR_input[i][2],'\nResult:',valueFromAI[1],valueFromAI[2],valueFromAI[3],valueFromAI[4],valueFromAI[5],valueFromAI[6],'\nError:',brain:getRMSE(XOR_output[i]))
            brain:saveWeights() -- pesos salvados após interaçao da rotina de treinamento
        end
    end
end

brain:loadWeights() -- pesos carregados para uso.

brain:save("voexcluir") -- forma de salvar os valores, pesos e bias da rede para poder utilizar pós treinamento.