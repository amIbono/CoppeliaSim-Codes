-- Primeiro criamos a funcao de inicializacao do sistema, igual o init no python, onde iremos definir as variaveis necessarias para o programa.

function sysCall_init()

    roboBase = sim.getObjectHandle(sim.handle_self)
    motorLeftBack = sim.getObjectHandle("MOTORBACKLEFT")
    motorRightBack = sim.getObjectHandle("MOTORBACKRIGHT")
    motorLeftFront = sim.getObjectHandle("MOTORFRONTLEFT")
    motorRightFront = sim.getObjectHandle("MOTORFRONTRIGHT")
    sensor = {-1,-1,-1}
    sensor[1] = sim.getObjectHandle("ProxSensor1") -- Sensor 1 le a frente do robo
    sensor[2] = sim.getObjectHandle("ProxSensor2") -- Sensor 2 le a esquerda do robo
    sensor[3] = sim.getObjectHandle("ProxSensor3") -- Sensor 3 le a direita do robo
    -- sim.getObject serve para ganharmos controle de determinada parte do robo, basta inserir o nome atual do objeto no robo.
    speed = 0
    speedTurnLeft = speed
    speedTurnRight = speed
    -- Velocidades maxima e minima postas para controle no programa.
end

-- Fun??o para movimentar o rob? pelo teclado, caso necess?rio.

function moveByKeyboard(auxiliaryData)
    if (auxiliaryData[1]==2007) then -- up key
        if speed <= 3 then
        speed = speed + 1
        speedTurnLeft = speed
        speedTurnRight = speed
        end
    end
    if (auxiliaryData[1]==2008) then -- down key
        if speed >= -3 then
        speed = speed - 1
        speedTurnLeft = speed
        speedTurnRight = speed
        end
    end
    if (auxiliaryData[1]==2009) then -- left key
        if speed <= 3 and speed >= -3 then
        speedTurnLeft = speed * 0.3
        speedTurnRight = speed * 0.7
        end
    end
    if (auxiliaryData[1]==2010) then -- right key
        if speed <= 3 and speed >= -3 then
        speedTurnLeft = speed * 0.7
        speedTurnRight = speed * 0.3
        end
    end
    sim.setJointTargetVelocity(motorLeftBack,speedTurnLeft)
    sim.setJointTargetVelocity(motorRightBack,speedTurnRight)
    sim.setJointTargetVelocity(motorLeftFront,speedTurnLeft)
    sim.setJointTargetVelocity(motorRightFront,speedTurnRight)
end

-- Fun??o para inserir a velocidade desejada em cada uma das rodas.

function setSpeed(var)
    if var == 0 then
        speedTurnLeft = speed
        speedTurnRight = speed
    end

    if var == 1 then
        speedTurnLeft = speed * 0.3
        speedTurnRight = speed * 0.7
    end

    if var == 2 then
        speedTurnLeft = speed * 0.7
        speedTurnRight = speed * 0.3
    end

    sim.setJointTargetVelocity(motorLeftBack,speedTurnLeft)
    sim.setJointTargetVelocity(motorRightBack,speedTurnRight)
    sim.setJointTargetVelocity(motorLeftFront,speedTurnLeft)
    sim.setJointTargetVelocity(motorRightFront,speedTurnRight)
end
-- Segundamente iremos criar a funcao principal, da qual ira atuar enquanto o simulador estiver ligado, ate que se interrompa a simulacao.

function sysCall_actuation()
    sensorReading = {false,false,false}
    for i = 1,3,1 do
        result = sim.handleProximitySensor(sensor[i])
        if result == 1 then
            sensorReading[i] = true
        end
    end

    message,auxiliaryData=sim.getSimulatorMessage() -- getSimulatorMessage capta as teclas inseridas no teclado durante a simulacao, permitindo controlar o robo por teclas no teclado.
    if message ~= -1 then
        moveByKeyboard(auxiliaryData)
    
    else
        if sensorReading[1] and not sensorReading[2] and not sensorReading[3] then
            speed = 1
            setSpeed(0)
        end

        if sensorReading[2] and not sensorReading[1] and not sensorReading[3] then
            speed = 1
            setSpeed(1)
        end

        if sensorReading[3] and not sensorReading[1] and not sensorReading[2] then
            speed = 1
            setSpeed(2)
        end

        if not sensorReading[1] and not sensorReading[2] and not sensorReading[3] then
            speed = 0
            setSpeed(0)
        end
    end

    --[[if sim.isHandle(roboBase) ~= true or sim.isHandle(motorLeft) ~= true or sim.isHandle(motorRight) ~= true then
        print(sim.isHandle(roboBase)," : ",sim.isHandle(motorLeft)," : ", sim.isHandle(motorRight))
    end--]]
    -- Neste if verificamos se o programa ainda reconhece os objetos, para caso de alguma forma ele perca a conexao com algum dos objetos do robo, sera avisado no terminal.

end
