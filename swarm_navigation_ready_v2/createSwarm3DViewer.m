function createSwarm3DViewer()
% createSwarm3DViewer
% Creates a Simulink model named Swarm3DViewer.slx.
% It visualizes 3 UAV trajectories using Simulation 3D UAV Vehicle blocks.

    modelName = "Swarm3DViewer";

    if bdIsLoaded(modelName)
        close_system(modelName,0);
    end

    new_system(modelName);
    open_system(modelName);

    try
        load_system("sim3dlib");
    catch
    end

    try
        load_system("uavsim3dlib");
    catch
    end

    %% Scene Configuration
    sceneBlk = modelName + "/Simulation 3D Scene Configuration";

    add_block("sim3dlib/Simulation 3D Scene Configuration", sceneBlk, ...
        "Position", [500 80 760 180]);

    set_param(sceneBlk, "Priority", "0");

    %% UAV Vehicle blocks
    vehicleLib = "uavsim3dlib/Simulation 3D UAV Vehicle";

    vehicle1 = modelName + "/Simulation 3D UAV Vehicle_UAV1";
    vehicle2 = modelName + "/Simulation 3D UAV Vehicle_UAV2";
    vehicle3 = modelName + "/Simulation 3D UAV Vehicle_UAV3";

    add_block(vehicleLib, vehicle1, "Position", [520 270 790 350]);
    add_block(vehicleLib, vehicle2, "Position", [520 430 790 510]);
    add_block(vehicleLib, vehicle3, "Position", [520 590 790 670]);

    set_param(vehicle1, "Priority", "-1");
    set_param(vehicle2, "Priority", "-1");
    set_param(vehicle3, "Priority", "-1");

    configureUAVVehicle(vehicle1, "SimulinkVehicle1", "1", "Blue",  "[0 0 12]");
    configureUAVVehicle(vehicle2, "SimulinkVehicle2", "2", "Red",   "[0 -4 12]");
    configureUAVVehicle(vehicle3, "SimulinkVehicle3", "3", "Green", "[0 4 12]");

    %% From Workspace blocks
    addFromWorkspace(modelName, "uav1TranslationTS", [80 250 260 290]);
    addFromWorkspace(modelName, "uav1RotationTS",    [80 320 260 360]);

    addFromWorkspace(modelName, "uav2TranslationTS", [80 410 260 450]);
    addFromWorkspace(modelName, "uav2RotationTS",    [80 480 260 520]);

    addFromWorkspace(modelName, "uav3TranslationTS", [80 570 260 610]);
    addFromWorkspace(modelName, "uav3RotationTS",    [80 640 260 680]);

    %% Connections
    connectPair(modelName, "uav1TranslationTS", "uav1RotationTS", vehicle1);
    connectPair(modelName, "uav2TranslationTS", "uav2RotationTS", vehicle2);
    connectPair(modelName, "uav3TranslationTS", "uav3RotationTS", vehicle3);

    %% Stop time
    if evalin("base", "exist('swarm3DStopTime','var')")
        stopTime = evalin("base", "swarm3DStopTime");
        set_param(modelName, "StopTime", num2str(stopTime));
    else
        set_param(modelName, "StopTime", "20");
    end

    save_system(modelName, "Swarm3DViewer.slx");

    disp("Swarm3DViewer.slx created successfully.");
end


function addFromWorkspace(modelName, varName, pos)
    blk = modelName + "/" + varName;

    add_block("simulink/Sources/From Workspace", blk, ...
        "Position", pos);

    set_param(blk, "VariableName", varName);
    set_param(blk, "SampleTime", "-1");
end


function connectPair(modelName, translationBlockName, rotationBlockName, vehicleBlock)
    transBlk = modelName + "/" + translationBlockName;
    rotBlk   = modelName + "/" + rotationBlockName;

    transPh = get_param(transBlk, "PortHandles");
    rotPh   = get_param(rotBlk, "PortHandles");
    vehPh   = get_param(vehicleBlock, "PortHandles");

    add_line(modelName, transPh.Outport(1), vehPh.Inport(1), "autorouting", "on");
    add_line(modelName, rotPh.Outport(1),   vehPh.Inport(2), "autorouting", "on");
end


function configureUAVVehicle(vehicleBlk, actorName, idValue, colorValue, initialTranslation)
    vals = get_param(vehicleBlk, "MaskValues");

    % Known Simulation 3D UAV Vehicle mask indices:
    % 3  = Color
    % 4  = ActorName
    % 6  = InitialTranslation
    % 13 = ID
    % 15 = ActorTag

    if numel(vals) >= 15
        vals{3}  = char(colorValue);
        vals{4}  = char(actorName);
        vals{6}  = char(initialTranslation);
        vals{13} = char(idValue);
        vals{15} = char(actorName);

        set_param(vehicleBlk, "MaskValues", vals);
    else
        warning("Unexpected mask format for block: %s", vehicleBlk);
    end
end
