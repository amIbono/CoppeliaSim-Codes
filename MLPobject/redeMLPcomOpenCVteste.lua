mlp = require "MLPtanh"                 -- import da biblioteca
brain = mlp.create()                -- criando a rede MLP, se for somente usar a rede treinada, nao é necessario indicar o valor de learningRate
brain:addLayer(1)                       -- 1 layer: inputs, com 2 variaveis de entrada
brain:addLayer(10)                       -- 2 layer: hidden layer, com 2 variaveis
brain:addLayer(6)                       -- 3 layer: output layer, com 1 variavel de saida
brain:load("voexcluir")             -- carrega a rede treinada

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

incorrect = 0 ; correct = incorrect

error = 0.1 ; interactions = 100000 --epocas

--[[
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

--]]

floor = {0,29,0} ; white = {0,255,0} ; green = {59,144,255}
red = {118,142,255} ; blue = {0,139,255} ; black = {0,23,0}

showDetectedColor = false

function recognizeColor(result)
    if result[6] >= 0.9 then -- white
            --print("white")
            return "white"
        
    --[[elseif listColors[6] >= 0.94 then -- border
        turnBack()
        if showDetectedColor == true then
            print("border")
            showDetectedColor = false
        end--]]
        
     elseif result[2] >= 0.9 then -- black
            --print("black")
            return "black"

    elseif result[4] >= 0.9 then -- red
            --print("red")
            return "red"

    elseif result[5] >= 0.9 then -- green
            --print("green")
            return "green"

    elseif result[3] >= 0.9 then -- blue
            --print("blue")
            return "blue"

    elseif result[1] >= 0.9 then -- floor
            --print('floor')
            return "floor"
    end
end

-- for green = {59,144,255}

for i = 1,interactions do
    value = {green[1] + randomFloat(-error,error),green[2] + randomFloat(-error,error), green[3] + randomFloat(-error,error)}
    --print(value[1],value[2],value[3])
    result = brain:forwardProp(value)
    color = recognizeColor(result)
    
    if color == "green" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('green',correct,incorrect,"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--[[
-- for red
--
for i = 1,interactions do
    value = {0.39215686917305 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error),(1 - error) + randomFloat(-error,error),
            0.11372549086809 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error)}
    result = brain:forwardProp(value)
    color = recognizeColor(result)


    if color == "red" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('red',"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--

-- for blue
--
for i = 1,interactions do
    value = {0.39215686917305 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error),
            0.11372549086809 + randomFloat(-error,error),(1 - error) + randomFloat(-error,error)}
    result = brain:forwardProp(value)
    color = recognizeColor(result)


    if color == "blue" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('blue',"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--

-- for black
--
for i = 1,interactions do
    value = {0.39215686917305 + randomFloat(-error,error),0.0,0.11372549086809 + randomFloat(-error,error),
            0.11372549086809 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error)}
    result = brain:forwardProp(value)
    color = recognizeColor(result)

    if color == "black" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('black',"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--


-- for floor
--
for i = 1,interactions do
    value = {0.39215686917305 + randomFloat(-error,error),0.11372549086809,0.11372549086809 + randomFloat(-error,error),
            0.11372549086809 + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error)}
    result = brain:forwardProp(value)
    color = recognizeColor(result)

    if color == "floor" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('floor',"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--

-- for white
--
for i = 1,interactions do
    value = {(1-error) + randomFloat(-error,error),0.11372549086809 + randomFloat(-error,error),(1-error) + randomFloat(-error,error),
            (1-error) + randomFloat(-error,error),(1-error) + randomFloat(-error,error)}
    result = brain:forwardProp(value)
    color = recognizeColor(result)

    if color == "white" then
        correct = correct + 1
    else
        incorrect = incorrect + 1
    end
end
print('white',"acurracy rate:",(((correct/interactions)*100).."%")) ; incorrect = 0 ; correct = incorrect
--]]