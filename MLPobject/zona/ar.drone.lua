function sysCall_init() 
    particlesAreVisible=true -- Variáveis que determinam se a pessoa quer q as particulas sejam visíveis, que sejam calculadas e a sombra do robo
    simulateParticles=true
    fakeShadow=true
    
    particleCountPerSecond=430 -- Variáveis iniciais, servem como parâmetro para a criação das partículas
    particleSize=0.005
    particleDensity=8500
    particleScatteringAngle=30
    particleLifeTime=0.5
    maxParticleCount=50

    -- Detatch the manipulation sphere:
    targetObj=sim.getObject('./target') -- Faz com que a esfera passe a ser filha do objeto base do drone, assim como pega o id da esfera (não é a base utilizada para calculo, essa é a denominada "base")
    sim.setObjectParent(targetObj,-1,true)

    -- This control algo was quickly written and is dirty and not optimal. It just serves as a SIMPLE example (Aqui ele explica que o código não tá limpo, meio obvio de ver)
    d=sim.getObject('./base') -- d é nome utilizado como referência ao objeto de base, o "base", que é utilizado nos calculos.

    propellerHandles={} -- lista para pegar cada objeto responsivo de cada propulsor
    jointHandles={}     -- lista para pegar cada joint que irá rodar as hélices
    particleObjects={-1,-1,-1,-1} -- lista de cada partícula
    local ttype=sim.particle_roughspheres+sim.particle_cyclic+sim.particle_respondable1to4+sim.particle_respondable5to8+sim.particle_ignoresgravity -- seta cada propriedade das particulas
    if not particlesAreVisible then -- caso a pesssoa decida tornar as partículas não visíveis, as partículas ganham o atributo de invisíveis.
        ttype=ttype+sim.particle_invisible
    end
    for i=1,4,1 do
        propellerHandles[i]=sim.getObject('./propeller['..(i-1)..']/respondable') --  gerando cada id de cada responsivo do propulsor e das joints 
        jointHandles[i]=sim.getObject('./propeller['..(i-1)..']/joint')
        if simulateParticles then -- se simulateParticles = true, irá gerar as partículas aq
            particleObjects[i]=sim.addParticleObject(ttype,particleSize,particleDensity,{2,1,0.2,3,0.4},particleLifeTime,maxParticleCount,{0.3,0.7,1})
        end
    end
    heli=sim.getObject('.') -- pega a id do quadcopter, é utilizado para detectar a velocidade do drone.

    pParam=2 -- parametros de multiplicação da velocidade vertical e horizontal
    iParam=0 -- iparam, cumul, dparam e lastE são inúteis para o cálculo da vertical
    dParam=0
    vParam=-2

    cumul=0 
    lastE=0
    pAlphaE=0
    pBetaE=0
    psp2=0
    psp1=0

    prevEuler=0


    if (fakeShadow) then -- criação dos parametros da sombra do drone
        shadowCont=sim.addDrawingObject(sim.drawing_discpoints+sim.drawing_cyclic+sim.drawing_25percenttransparency+sim.drawing_50percenttransparency+sim.drawing_itemsizes,0.2,0,-1,1)
    end
end

function sysCall_cleanup() 
    sim.removeDrawingObject(shadowCont) -- codigo de limpeza dos objetos desenhados pelo drone
    for i=1,#particleObjects,1 do
        sim.removeParticleObject(particleObjects[i])
    end
end 

function sysCall_actuation() 
    pos=sim.getObjectPosition(d,-1) -- codigo para criar o desenho da sombra do drone
    if (fakeShadow) then
        itemData={pos[1],pos[2],0.002,0,0,1,0.2}
        sim.addDrawingObjectItem(shadowCont,itemData)
    end
    
    -- Vertical control:
    targetPos=sim.getObjectPosition(targetObj,-1) --[[  iparam, cumul, dparam e lastE não são necessários, logo os únicos necessários para o cálculo são:
    targetPos=sim.getObjectPosition(targetObj,-1)
    pos=sim.getObjectPosition(d,-1)
    l=sim.getVelocity(heli)
    e=(targetPos[3]-pos[3])
    pv=pParam*e
    thrust=5.45+pv+l[3]*vParam
    --]]
    pos=sim.getObjectPosition(d,-1)
    l=sim.getVelocity(heli)
    e=(targetPos[3]-pos[3])
    cumul=cumul+e
    pv=pParam*e
    thrust=5.45+pv+iParam*cumul+dParam*(e-lastE)+l[3]*vParam -- iParam zera o valor cumul, dParam zera "e" e lastE, porém "e" ainda é util para pv.
    lastE=e -- thrust é utilizado para o calculo das forças e torque exercidas no drone, assim como as partículas dele
    
    -- Horizontal control: 
    sp=sim.getObjectPosition(targetObj,d) -- pega a posição do target em relação a base do drone
    m=sim.getObjectMatrix(d,-1) -- é feita a matriz de transformação em relação a base do drone
    vx={1,0,0}
    vx=sim.multiplyVector(m,vx) -- é feita uma multiplicação matricial em relação a x (vx) e y (vy)
    vy={0,1,0}
    vy=sim.multiplyVector(m,vy)
    alphaE=(vy[3]-m[12]) -- valor alphaE, terceiro valor da mult. matricial - terceira translação da matriz do objeto
    alphaCorr=0.25*alphaE+2.1*(alphaE-pAlphaE)  -- é pego o valor alphaE para se encontrar a correção em alpha do eixo z da matriz encontrada, prov. foi encontrada baseada em testes. alphaE - pAlphaE é feita para criar uma diferença entre a antiga alphaE com a nova.
    betaE=(vx[3]-m[12])
    betaCorr=-0.25*betaE-2.1*(betaE-pBetaE) -- o mesmo é feito para se encontrar a correção em beta
    pAlphaE=alphaE
    pBetaE=betaE
    alphaCorr=alphaCorr+sp[2]*0.005+1*(sp[2]-psp2) -- logo depois é somado as correções em alpha de y da matriz encontrada
    betaCorr=betaCorr-sp[1]*0.005-1*(sp[1]-psp1) -- em beta é somado a correção em x da matriz
    psp2=sp[2]
    psp1=sp[1] 
    
    -- Rotational control:
    euler=sim.getObjectOrientation(d,targetObj) -- é pego o valor dos angulos da base do drone em relação ao target
    rotCorr=euler[3]*0.1+2*(euler[3]-prevEuler) -- é feito o cálculo de rotação do drone, que é baseado no eixo z.
    prevEuler=euler[3]
    
    -- Decide of the motor velocities: -- é feito as devidas correções em cada propulsor:
    handlePropeller(1,thrust*(1-alphaCorr+betaCorr+rotCorr)) -- propulsor da esquerda frente
    handlePropeller(2,thrust*(1-alphaCorr-betaCorr-rotCorr)) -- propulsor da esquerda atras
    handlePropeller(3,thrust*(1+alphaCorr-betaCorr+rotCorr)) -- propulsor da direita atras 
    handlePropeller(4,thrust*(1+alphaCorr+betaCorr-rotCorr)) -- propulsor da direita frente
end 


function handlePropeller(index,particleVelocity)
    propellerRespondable=propellerHandles[index]
    propellerJoint=jointHandles[index]
    propeller=sim.getObjectParent(propellerRespondable)
    particleObject=particleObjects[index]
    maxParticleDeviation=math.tan(particleScatteringAngle*0.5*math.pi/180)*particleVelocity
    notFullParticles=0

    local t=sim.getSimulationTime()
    sim.setJointPosition(propellerJoint,t*10)
    ts=sim.getSimulationTimeStep()
    
    m=sim.getObjectMatrix(propeller,-1)
    particleCnt=0
    pos={0,0,0}
    dir={0,0,1}
    
    requiredParticleCnt=particleCountPerSecond*ts+notFullParticles
    notFullParticles=requiredParticleCnt % 1
    requiredParticleCnt=math.floor(requiredParticleCnt)
    while (particleCnt<requiredParticleCnt) do
        -- we want a uniform distribution:
        x=(math.random()-0.5)*2
        y=(math.random()-0.5)*2
        if (x*x+y*y<=1) then
            if (simulateParticles) then
                pos[1]=x*0.08
                pos[2]=y*0.08
                pos[3]=-particleSize*0.6
                dir[1]=pos[1]+(math.random()-0.5)*maxParticleDeviation*2
                dir[2]=pos[2]+(math.random()-0.5)*maxParticleDeviation*2
                dir[3]=pos[3]-particleVelocity*(1+0.2*(math.random()-0.5))
                pos=sim.multiplyVector(m,pos)
                dir=sim.multiplyVector(m,dir)
                itemData={pos[1],pos[2],pos[3],dir[1],dir[2],dir[3]}
                sim.addParticleObjectItem(particleObject,itemData)
            end
            particleCnt=particleCnt+1
        end
    end
    -- Apply a reactive force onto the body:
    totalExertedForce=particleCnt*particleDensity*particleVelocity*math.pi*particleSize*particleSize*particleSize/(6*ts)
    force={0,0,totalExertedForce}
    m[4]=0
    m[8]=0
    m[12]=0
    force=sim.multiplyVector(m,force)
    local rotDir=1-math.mod(index,2)*2
    torque={0,0,rotDir*0.002*particleVelocity}
    torque=sim.multiplyVector(m,torque)
    sim.addForceAndTorque(propellerRespondable,force,torque)
end