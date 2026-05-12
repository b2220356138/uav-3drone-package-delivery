function prepareSwarm3DSignals()
% prepareSwarm3DSignals
% Converts swarm_navigation_simData.mat into timeseries signals for
% Simulation 3D UAV Vehicle blocks.
%
% Output variables:
% uav1TranslationTS
% uav2TranslationTS
% uav3TranslationTS
% uav1RotationTS
% uav2RotationTS
% uav3RotationTS
% swarm3DStopTime

    if ~isfile("swarm_navigation_simData.mat")
        error("swarm_navigation_simData.mat not found. Run Main_SwarmNavigation first.");
    end

    load("swarm_navigation_simData.mat","simData");

    if ~isfield(simData,"drones")
        error("simData.drones field not found.");
    end

    numDrones = numel(simData.drones);

    if numDrones < 3
        error("simData must contain at least 3 drones.");
    end

    n1 = numel(simData.drones(1).xTrajectory);
    n2 = numel(simData.drones(2).xTrajectory);
    n3 = numel(simData.drones(3).xTrajectory);

    N = min([n1 n2 n3]);

    if N < 2
        error("Trajectory length is too short.");
    end

    % Larger deltaT means slower playback in Simulation 3D.
    deltaT = 0.5;
    t = (0:N-1)' * deltaT;

    uav1Translation = [
        simData.drones(1).xTrajectory(1:N), ...
        simData.drones(1).yTrajectory(1:N), ...
        simData.drones(1).zTrajectory(1:N)
    ];

    uav2Translation = [
        simData.drones(2).xTrajectory(1:N), ...
        simData.drones(2).yTrajectory(1:N), ...
        simData.drones(2).zTrajectory(1:N)
    ];

    uav3Translation = [
        simData.drones(3).xTrajectory(1:N), ...
        simData.drones(3).yTrajectory(1:N), ...
        simData.drones(3).zTrajectory(1:N)
    ];

    % Fixed zero rotation for first Simulation 3D test: [roll pitch yaw].
    uav1Rotation = zeros(N,3);
    uav2Rotation = zeros(N,3);
    uav3Rotation = zeros(N,3);

    uav1TranslationTS = timeseries(uav1Translation, t);
    uav2TranslationTS = timeseries(uav2Translation, t);
    uav3TranslationTS = timeseries(uav3Translation, t);

    uav1RotationTS = timeseries(uav1Rotation, t);
    uav2RotationTS = timeseries(uav2Rotation, t);
    uav3RotationTS = timeseries(uav3Rotation, t);

    swarm3DStopTime = t(end);

    assignin("base","uav1TranslationTS",uav1TranslationTS);
    assignin("base","uav2TranslationTS",uav2TranslationTS);
    assignin("base","uav3TranslationTS",uav3TranslationTS);

    assignin("base","uav1RotationTS",uav1RotationTS);
    assignin("base","uav2RotationTS",uav2RotationTS);
    assignin("base","uav3RotationTS",uav3RotationTS);

    assignin("base","swarm3DStopTime",swarm3DStopTime);

    save("swarm_3d_signals.mat", ...
        "uav1TranslationTS", ...
        "uav2TranslationTS", ...
        "uav3TranslationTS", ...
        "uav1RotationTS", ...
        "uav2RotationTS", ...
        "uav3RotationTS", ...
        "swarm3DStopTime");

    disp("Simulation 3D signals prepared successfully.");
    fprintf("Number of trajectory samples: %d\n", N);
    fprintf("Simulation 3D stop time: %.2f seconds\n", swarm3DStopTime);
end
