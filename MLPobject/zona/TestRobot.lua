-- Primeiro criamos a funcao de inicializacao do sistema, igual o init no python, onde iremos definir as variaveis necessarias para o programa.

function sysCall_init()

    roboBase = sim.getObjectHandle(sim.handle_self)
    motorLeft = sim.getObjectHandle("LEFTMOTOR")
    motorRight = sim.getObjectHandle("RIGHTMOTOR")
    -- sim.getObject serve para ganharmos controle de determinada parte do robo, basta inserir o nome atual do objeto no robo.
    minSpeed = 1
    maxSpeed = 10
    -- Velocidades maxima e minima postas para controle no programa.
    contador = 0
end

-- Segundamente iremos criar a funcao principal, da qual ira atuar enquanto o simulador estiver ligado, ate que se interrompa a simulacao.

function sysCall_actuation()
    if sim.isHandle(roboBase) ~= true or sim.isHandle(motorLeft) ~= true or sim.isHandle(motorRight) ~= true then
        print(sim.isHandle(roboBase)," : ",sim.isHandle(motorLeft)," : ", sim.isHandle(motorRight))
    end
    -- Neste if verificamos se o programa ainda reconhece os objetos, para caso de alguma forma ele perca a conexao com algum dos objetos do robo, sera avisado no terminal.
    for i = 0, 10,1 do
        sim.setJointTargetVelocity(motorLeft,minSpeed)
        sim.setJointTargetVelocity(motorRight,minSpeed)
    end

    for j = 0, 10,1 do
        sim.setJointTargetVelocity(motorLeft,maxSpeed)
        sim.setJointTargetVelocity(motorRight,maxSpeed)
    end
end

