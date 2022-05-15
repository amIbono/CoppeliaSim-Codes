function sysCall_init()

    motor = {}
    floorSensorHandles={-1,-1,-1}
    sensorReading={false,false,false}
    speed = 10
    
    for i = 1,2,1 do
        motor[i] = sim.getObject('./Motor['..(i-1)..']')
    end
    
    for i = 1,3,1 do
        floorSensorHandles[i] = sim.getObject('./sensor['..(i-1)..']')
    end
end

function sysCall_actuation()
    for i=1,3,1 do
        result,data=sim.readVisionSensor(floorSensorHandles[i])
        if result >= 0 then
            sensorReading[i]=(data[11]<0.5)
        end
    end

    if sensorReading[2] == true and sensorReading[3] == false then
        sim.setJointTargetVelocity(motor[1],speed*(20/100))
        sim.setJointTargetVelocity(motor[2],speed*(80/100))
    end
    if sensorReading[3] == true and sensorReading[2] == false then
        sim.setJointTargetVelocity(motor[1],speed*(80/100))
        sim.setJointTargetVelocity(motor[2],speed*(20/100))
    end
    if sensorReading[1] == true and sensorReading[2] == false and sensorReading[3] == false then
        sim.setJointTargetVelocity(motor[1], speed)
        sim.setJointTargetVelocity(motor[2], speed)
    end
end
