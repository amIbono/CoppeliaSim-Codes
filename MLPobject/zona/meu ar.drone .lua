function sysCall_init()
    -- LEMBRETE: FAVOR COMENTAR O C?DIGO, NEM EU ENTENDO MAIS OQ EU FIZ
    
    caixa = sim.getObject("/Cuboid")
    helice = {}
    for i = 1,4,1 do
        helice[i] = sim.getObject('/Cylinder'..(i-1)..'')
    point = sim.getObject("/base")
    end
    force = {0,0,0}
    angles = {0,0,0}
    
    --[[ helice[0] front
         helice[1] back
         helice[2] right
         helice[3] left
         --]]
end

function sysCall_actuation() -- ajustar Z em X nas helices, ajustar X em Y nas helices, ajustar Y em Z nas helices
    position = sim.getObjectPosition(caixa,-1)
    pointPosition = sim.getObjectPosition(point,-1)
    for i = 1,4,1 do
        adjustZ = ((pointPosition[3] - position[3]+14.5646))/4
        adjustY = ((pointPosition[2] - position[2]^2))
        adjustX = ((pointPosition[1] - position[1]^2))
        force[1] = adjustX
        force[2] = adjustY
        force[3] = adjustZ
        sim.addForce(helice[i],position,force)
        sim.setObjectOrientation(caixa,-1,angles)
    end
end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- See the user manual or the available code snippets for additional callback functions and details
