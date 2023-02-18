mlp = require "MLP"
brain = mlp.create(0.03)
brain:addLayer(2)
brain:addLayer(10)
brain:addLayer(1)
XOR_input = {{-10,-10},{10,10},{-10,10},{10,-10}}
XOR_output = {{0},{1},{0.5},{0.5}}
brain:load("randomname")



--brain:transfer(0)

--brain:randomizeWeights()
--[[
for _ = 1,2 do
    for i = 1,4 do
        x = brain:forwardProp(XOR_input[i])
        brain:backwardProp(XOR_output[i])
        print(i,'valor?',x[1],'erro?',brain:getMSE(XOR_output[i]))
        brain:saveWeights()
    end
    
end
brain:loadWeights()
--]]

for i = 1,4 do
    x = brain:forwardProp(XOR_input[i])
    print(x[1])
end

--brain:save("randomname")