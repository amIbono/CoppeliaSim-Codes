function sysCall_init()
    targetObj = sim.getObject("/target") 
    base = sim.getObject("/base")
    normalHeight = 1.6480
    list1 = {}
    blue = {0,0,1}
    red = {1,0,0}
    green = {0,1,0}
    white = {1,1,1}
    black = {0,0,0}
    showDetectedColor = false
end

function sysCall_actuation()
    if detectedArray == nil then
    else
        recognizeColor()
    end
end

function sysCall_vision(inData)
    simVision.sensorImgToWorkImg(inData.handle) 
    local useless,values = simVision.blobDetectionOnWorkImg(inData.handle,0.15,0.01,false,{1,0,1})
    detectedArray = sim.unpackFloatTable(values)
    detectedColor = detectedArray[5]
    --print(detectedArray[5],detectedArray[6])
    state, listColors = sim.readVisionSensor(inData.handle)
    --print('max and min intensity:',listColors[6],listColors[1],'\n','RGB VALUES:',listColors[7],listColors[8],listColors[9])
    simVision.workImgToSensorImg(inData.handle)
    
end

function goForward()
    velocity = sim.getObjectVelocity(base)
    normalWalk = {0.05 - math.abs(velocity[1]/8),0.05 - math.abs(velocity[2]/8),0.005 - math.abs(velocity[3]/8)}
    sim.setObjectPosition(targetObj,base,normalWalk)
end

function turnBack()
    position = sim.getObjectPosition(targetObj,-1)
    angles = sim.getObjectOrientation(targetObj,-1)
    sim.setObjectPosition(targetObj,-1,{position[1],position[2],normalHeight})
    sim.setObjectOrientation(targetObj,-1,{angles[1],angles[2],angles[3] - 0.01})
end

function stop()
    position = sim.getObjectPosition(targetObj,-1)
    sim.setObjectPosition(targetObj,-1,{position[1],position[2],normalHeight})
end

function recognizeColor()

    if listColors[6] >= 0.99 then -- white
        stop()
        if showDetectedColor == true then
            print("white")
            showDetectedColor = false
        end
        
    elseif listColors[6] >= 0.94 then -- border
        turnBack()
        if showDetectedColor == true then
            print("border")
            showDetectedColor = false
        end
        
     elseif listColors[1] <= 0.01 then -- black
        stop()
        if showDetectedColor == true then
            print("black")
            showDetectedColor = false
        end

    elseif listColors[7] >= 0.99 then -- red
        goForward()
        if showDetectedColor == true then
            print("red")
            showDetectedColor = false
        end

    elseif listColors[8] >= 0.99 then -- green
        turnBack()
        if showDetectedColor == true then
            print("green")
            showDetectedColor = false
        end

    elseif listColors[9] >= 0.99 then -- blue
        goForward()
        if showDetectedColor == true then
            print("blue")
            showDetectedColor = false
        end
    else
        goForward()
        showDetectedColor = true
    end
end

--[[

--simVision.colorSegmentationOnWorkImg(inData.handle,0.1)
--simVision.coordinatesFromWorkImg
--simVision.selectiveColorOnWorkImg(inData.handle,white,{0.1,0.1,0.1},true,true,false)
REMEMBER:
max intensity 0.9490 = border
min intensity 0.0 = black
max intensity 1.0 = white
max blue 1.0 = blue
max red 1.0 = red
max green 1.0 = green

--]]