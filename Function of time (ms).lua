--[[
This function is on lua, so maybe if you want to port this to python, just adjust some parameters and it will work. 
First it's a time wait that needs to put this initial variable on the sysCall_init().

1º function
--]]
function sysCall_init()
    realTimerCounter = sim.getSystemTimeInMs(-1)
end

function timeOnMs(time)
    if sim.getSystemTimeInMs(realTimerCounter) >= time then
        -- you can put whatever code you want here
        realTimerCounter = sim.getSystemTimeInMs(-1)
    else
        return
    end
end

--[[
To call the function simply use timeOnMs(timeonMs) on any part of your code, an example: timeOnMs(1000), to make a wait function with 1000ms, or 1s.
That function is way more shorter, but if you want the larger one and all closed, you can use that other function.

2º Function
--]]
function timeOnMs(time)
    if firstTimeOnFunction == nil or firstTimeOnFunction == true then
        firstTimeOnFunction = false
        realTimerCounter = sim.getSystemTimeInMs(-1)
        compareRealTimerCounter = sim.getSystemTimeInMs(realTimerCounter)
        return
    end
    if compareRealTimerCounter >= time then
        firstTimeOnFunction = true
        print(compareRealTimerCounter)
        return
    end
    if firstTimeOnFunction == false then
        compareRealTimerCounter = sim.getSystemTimeInMs(realTimerCounter)
        return
    end
end

--[[
This function works without any initial parameter, but it's more complex and maybe will lead to more delay to finish the function, 
you can test the total time spend just removing the "" that's on the function.
Both functions will lead to the wait on the process, and will just need the adjust to implement it on each code, as it don't pause your code when it's working on.
To use the second, you can use a if timeOnMs("just a example" 1000 ) == true then (put your code here), and put a return true on the second if, like this:
--]]
function sysCall_actuation()
    if timeOnMs(1000) == true then
        print("it's working")
    end
end

function timeOnMs(time)
    if firstTimeOnFunction == nil or firstTimeOnFunction == true then
        firstTimeOnFunction = false
        realTimerCounter = sim.getSystemTimeInMs(-1)
        compareRealTimerCounter = sim.getSystemTimeInMs(realTimerCounter)
        return
    end
    
    if compareRealTimerCounter >= time then
        firstTimeOnFunction = true
        return true
    end
    
    if firstTimeOnFunction == false then
        compareRealTimerCounter = sim.getSystemTimeInMs(realTimerCounter)
        return
    end
end

-- All codes doesn't own licenses, use it at your free will.
