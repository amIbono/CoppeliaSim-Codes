mlp = require 'MLP'
    
brain = mlp.create(0.03)
brain:addLayer(5)
brain:addLayer(10)
brain:addLayer(6)
brain:setMomentum(0.001)

XOR_input = {{0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809,0.11372549086809}, -- floor
{0.11372549086809,0.0,0.11372549086809,0.11372549086809,0.11372549086809}, -- black
{0.39215686917305,0.11372549086809,0.11372549086809,0.11372549086809,1.0}, -- blue
{0.39215686917305,0.11372549086809,1.0,0.11372549086809,0.11372549086809}, -- red
{0.39215686917305,0.11372549086809,0.11372549086809,1.0,0.11372549086809}, -- green
{1.0,0.11372549086809,1.0,1.0,1.0}} -- white

XOR_output =  {{1,0,0,0,0,0},{0,1,0,0,0,0},{0,0,1,0,0,0},{0,0,0,1,0,0},{0,0,0,0,1,0},{0,0,0,0,0,1}} -- floor, black, blue, red, green, white


for _ = 1,2500 do
    for i = 1,6 do
            x = brain:forwardProp(XOR_input[i])
            brain:backwardProp(XOR_output[i])
            print(i,'valor?',x[1],x[2],x[3],x[4],x[5],x[6],'erro?',brain:getMSE(XOR_output[i]))
            brain:saveWeights()
    end
end
