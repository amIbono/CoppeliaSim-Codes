mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create(0.03)                -- criando a rede MLP com learnig rate de 0.03
brain:addLayer(2)                       -- 1 layer: inputs, com 2 variaveis de entrada
brain:addLayer(2)                       -- 2 layer: hidden layer, com 2 variaveis
brain:addLayer(1)                       -- 3 layer: output layer, com 1 variavel de saida

brain:setMomentum(0.001)                -- momentum de 0.001, já que valores maiores tendem a não se aproximar do resultado esperado
errorCoeficient = 0.01                  -- coeficiente de erro, utilizado para a rotina de treinamento, finaliza a rotina caso o erro seja menor que o posto.
RMSE = 1                                -- valor de erro quadrático, utilizado para a rotina de treinamento, se ajusta conforme o erro encontrado pela funçao
interations = 1000000000                    -- numero de interações máximo

XOR_input = {{0,0},{1,1},{1,0},{0,1}}   -- input e output, usados para treinamento da rede
XOR_output = {{0},{0},{1},{1}}

--brain:transfer(0) 
--brain:randomizeWeights()

for _ = 1,interations do                -- rotina de treinamento, onde sao feitas n interações, encontrado o valor na funçao pelo propagation, e reajustado os pesos no backpropagation.
                                        -- O valor de erro quadrático encontrado com o resultado esperado é avaliado com o erro minimo posto, assim finalizando a rotina de treinamento.
    if RMSE < errorCoeficient then
        break
    else
        for i = 1,4 do
            valueFromAI = brain:forwardProp(XOR_input[i])
            brain:backwardProp(XOR_output[i])
            RMSE = brain:getRMSE(XOR_output[i])
            print('Input:',XOR_input[i][1],XOR_input[i][2],'Result:',valueFromAI[1],'Error:',brain:getRMSE(XOR_output[i]))
            brain:saveWeights() -- pesos salvados após interaçao da rotina de treinamento
        end
    end
end

brain:loadWeights() -- pesos carregados para uso.

brain:save("REDEMLPTANH") -- forma de salvar os valores, pesos, bias, da rede e poder utilizar pós treinamento.