function sysCall_init()
    corout=coroutine.create(coroutineMain)
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    end
end

-- This script is threaded! It is a very simple example of how Ackermann steering can be handled.
-- Normally, one would use a non-threaded script for that

function coroutineMain()
    -- Put some initialization code here:
    -- Retrieving of some handles and setting of some initial values:
    steeringLeft=sim.getObjectHandle('nakedCar_steeringLeft')
    steeringRight=sim.getObjectHandle('nakedCar_steeringRight')
    motorLeft=sim.getObjectHandle('nakedCar_motorLeft')
    motorRight=sim.getObjectHandle('nakedCar_motorRight')
    desiredSteeringAngle=0
    desiredWheelRotSpeed=0
    steeringAngleDx=2*math.pi/180
    wheelRotSpeedDx=20*math.pi/180
    d=0.755 -- 2*d=distance between left and right wheels
    l=2.5772 -- l=distance between front and read wheels

    -- Main routine:
    while true do
        -- Read the keyboard messages (make sure the focus is on the main window, scene view):
        message,auxiliaryData=sim.getSimulatorMessage()
        while message~=-1 do
            if (message==sim.message_keypress) then
                if (auxiliaryData[1]==2007) then
                    -- up key
                    desiredWheelRotSpeed=desiredWheelRotSpeed+wheelRotSpeedDx
                end
                if (auxiliaryData[1]==2008) then
                    -- down key
                    desiredWheelRotSpeed=desiredWheelRotSpeed-wheelRotSpeedDx
                end
                if (auxiliaryData[1]==2009) then
                    -- left key
                    desiredSteeringAngle=desiredSteeringAngle+steeringAngleDx
                    if (desiredSteeringAngle>45*math.pi/180) then
                        desiredSteeringAngle=45*math.pi/180
                    end
                end
                if (auxiliaryData[1]==2010) then
                    -- right key
                    desiredSteeringAngle=desiredSteeringAngle-steeringAngleDx
                    if (desiredSteeringAngle<-45*math.pi/180) then
                        desiredSteeringAngle=-45*math.pi/180
                    end
                end
            end
            message,auxiliaryData=sim.getSimulatorMessage()
        end

        -- We handle the front left and right wheel steerings (Ackermann steering):
        steeringAngleLeft=math.atan(l/(-d+l/math.tan(desiredSteeringAngle)))
        steeringAngleRight=math.atan(l/(d+l/math.tan(desiredSteeringAngle)))
        sim.setJointTargetPosition(steeringLeft,steeringAngleLeft)
        sim.setJointTargetPosition(steeringRight,steeringAngleRight)

        -- We take care of setting the desired wheel rotation speed:
        sim.setJointTargetVelocity(motorLeft,desiredWheelRotSpeed)
        sim.setJointTargetVelocity(motorRight,desiredWheelRotSpeed)

        -- Since this script is threaded, don't waste time here:
        sim.switchThread() -- Resume the script at next simulation loop start
    end
end
