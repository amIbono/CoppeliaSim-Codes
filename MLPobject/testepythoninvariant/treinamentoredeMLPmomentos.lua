mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create(0.03)                -- criando a rede MLP com learnig rate de 0.03
brain:addLayer(7)                       -- 1 layer: inputs, com 1 variaveis de entrada
brain:addLayer(30)                       -- 2 layer: hidden layer, com 10 variaveis
brain:addLayer(30)  
brain:addLayer(2)                       -- 3 layer: output layer, com 1 variavel de saida

brain:setMomentum(0.001)                -- momentum de 0.001, já que valores maiores tendem a não se aproximar do resultado esperado
errorCoeficient = 0.001                  -- coeficiente de erro, utilizado para a rotina de treinamento, finaliza a rotina caso o erro seja menor que o posto.
RMSE = 1                                -- valor de erro quadrático, utilizado para a rotina de treinamento, se ajusta conforme o erro encontrado pela funçao
interations = 500                   -- numero de interações máximo

error = 0.1
XOR_input = {}
XOR_output = {0,1}
for _ = 1,interations do                -- rotina de treinamento, onde sao feitas n interações, encontrado o valor na funçao pelo propagation, e reajustado os pesos no backpropagation.
                                        -- O valor de erro quadrático encontrado com o resultado esperado é avaliado com o erro minimo posto, assim finalizando a rotina de treinamento.
    if RMSE < errorCoeficient then
        break
    else
        for i = 1,5000 do
        
            file = io.open("text.txt",r)
            for j = 1,7 do
                XOR_input[j] = file:read("n")
            end
            io.close(file)

            valueFromAI = brain:forwardProp(XOR_input)
            brain:backwardProp(XOR_output)
            RMSE = brain:getRMSE(XOR_output)
            print('\nResult:',valueFromAI[1],valueFromAI[2],'\nError:',RMSE)
            brain:saveWeights() -- pesos salvados após interaçao da rotina de treinamento
        end
    end
end

brain:loadWeights() -- pesos carregados para uso.

brain:save("redeMLPdomomentos") -- forma de salvar os valores, pesos e bias da rede para poder utilizar pós treinamento.