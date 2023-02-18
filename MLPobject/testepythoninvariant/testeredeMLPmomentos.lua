mlp = require "MLPtanh"                 -- import da biblioteca

brain = mlp.create()                -- criando a rede MLP com learnig rate de 0.03
brain:addLayer(7)                       -- 1 layer: inputs, com 1 variaveis de entrada
brain:addLayer(30)                       -- 2 layer: hidden layer, com 10 variaveis
brain:addLayer(30)  
brain:addLayer(2)                       -- 3 layer: output layer, com 1 variavel de saida
brain:load("redeMLPdomomentos")

interations = 2                   -- numero de interações máximo

error = 0.1
XOR_input = {}
for _ = 1,interations do                -- rotina de treinamento, onde sao feitas n interações, encontrado o valor na funçao pelo propagation, e reajustado os pesos no backpropagation.
        
        file = io.open("text.txt",r)
        for j = (7*_)-6,(7*_) do
            print(j)
            XOR_input[j] = file:read("n")
        end
        io.close(file)

        valueFromAI = brain:forwardProp(XOR_input)
        print('\nResult:',valueFromAI[1],valueFromAI[2])
end