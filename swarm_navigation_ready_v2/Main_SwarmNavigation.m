clear; close all; clc;

% Main_SwarmNavigation
% 3-UAV swarm simulation:
% - Generate building map
% - Plan shortest safe path from A to B using A* on an occupancy grid
% - Fly Alpha, Beta1, Beta2 side-by-side in formation
% - Avoid buildings using inflated occupancy map
%
% Coordinate convention:
% position = [x; y; z] in meters
% z is fixed altitude in this simplified simulation.

%% Initializing the parameters

deltaT = 0.1;                  % simulation step in seconds

params.maxSteps = 20000;       % high enough so drones can finish the path
params.uavSpeed = 8.0;         % m/s, increase if figure simulation is too slow
params.formationSpacing = 2.0; % Alpha-Beta distance in meters
params.buildingClearance = 3.0; % extra safety clearance from buildings
params.gridResolution = 1.0;    % meter/cell
params.altitude = 20.0;         % flight altitude in meters

%% Generating the Map

% Create static building map.
Map = GenerateMap();

%% Operator command: A to B task

% Mission start and goal.
% All UAVs must start consistently from this mission start area.
missionStart = [-45; -45; params.altitude];
missionGoal  = [45; 45; params.altitude];

Operator2AlphaMessage = Operator2AlphaCommunication();
Operator2AlphaMessage.StartPoint = missionStart;
Operator2AlphaMessage.GoalPoint  = missionGoal;
Operator2AlphaMessage.Command = "GO_TO_POINT";

%% UAV Initialization

% IMPORTANT:
% UAVs must be initialized at the same start position used by the mission.
% Previously UAVs started at [0;0;altitude], then the path started at [-45;-45;altitude].
% That caused the drones to first fly from [0,0] to the path start.
% This is now fixed.

AlphaUAV = InitializeUAV( ...
    "Alpha", ...
    missionStart, ...
    [0;0;0], ...
    "Leader");

BetaUAV1 = InitializeUAV( ...
    "Beta1", ...
    missionStart + [0; -params.formationSpacing; 0], ...
    [0;0;0], ...
    "Left Wing");

BetaUAV2 = InitializeUAV( ...
    "Beta2", ...
    missionStart + [0;  params.formationSpacing; 0], ...
    [0;0;0], ...
    "Right Wing");

%% Calculate the full formation path once

MissionPlan = CalculateNextPositions( ...
    Operator2AlphaMessage, ...
    AlphaUAV, BetaUAV1, BetaUAV2, ...
    Map, params);

if ~MissionPlan.Success
    error("Path planning failed: %s", MissionPlan.Message);
end

AlphaUAV.Path = MissionPlan.AlphaPath;
BetaUAV1.Path = MissionPlan.Beta1Path;
BetaUAV2.Path = MissionPlan.Beta2Path;

AlphaUAV.PathIndex = 1;
BetaUAV1.PathIndex = 1;
BetaUAV2.PathIndex = 1;

%% Visualization setup

figure("Name","3-UAV Swarm Navigation");

PlotMap3D(Map);
hold on;
grid on;
axis equal;

xlabel("X (m)");
ylabel("Y (m)");
zlabel("Z (m)");

title("3-UAV Side-by-Side A* Navigation Between Buildings");
view(3);

% Plot planned paths
plot3(AlphaUAV.Path(1,:), AlphaUAV.Path(2,:), AlphaUAV.Path(3,:), ...
    "b-", "LineWidth", 2);

plot3(BetaUAV1.Path(1,:), BetaUAV1.Path(2,:), BetaUAV1.Path(3,:), ...
    "r-", "LineWidth", 1.5);

plot3(BetaUAV2.Path(1,:), BetaUAV2.Path(2,:), BetaUAV2.Path(3,:), ...
    "g-", "LineWidth", 1.5);

% Plot UAV markers
hAlpha = plot3( ...
    AlphaUAV.Positions(1,end), ...
    AlphaUAV.Positions(2,end), ...
    AlphaUAV.Positions(3,end), ...
    "bo", "MarkerSize", 10, "LineWidth", 2);

hBeta1 = plot3( ...
    BetaUAV1.Positions(1,end), ...
    BetaUAV1.Positions(2,end), ...
    BetaUAV1.Positions(3,end), ...
    "ro", "MarkerSize", 10, "LineWidth", 2);

hBeta2 = plot3( ...
    BetaUAV2.Positions(1,end), ...
    BetaUAV2.Positions(2,end), ...
    BetaUAV2.Positions(3,end), ...
    "go", "MarkerSize", 10, "LineWidth", 2);

legend( ...
    "Buildings", ...
    "Alpha path", ...
    "Beta1 path", ...
    "Beta2 path", ...
    "Alpha", ...
    "Beta1", ...
    "Beta2");

%% Simulation

FinishSimulation = false;
step = 1;

while ~FinishSimulation && step <= params.maxSteps

    %% Communication: Alpha to Beta UAVs

    Alpha2Beta1TransmittedMessage = AlphaSendMessageToBeta(BetaUAV1);
    Alpha2Beta2TransmittedMessage = AlphaSendMessageToBeta(BetaUAV2);

    Alpha2Beta1ReceivedMessage = DecodeReceivedMessage(Alpha2Beta1TransmittedMessage); %#ok<NASGU>
    Alpha2Beta2ReceivedMessage = DecodeReceivedMessage(Alpha2Beta2TransmittedMessage); %#ok<NASGU>

    %% Path following

    [AlphaUAV, alphaDone] = FollowPathOneStep(AlphaUAV, deltaT, params.uavSpeed);
    [BetaUAV1, beta1Done] = FollowPathOneStep(BetaUAV1, deltaT, params.uavSpeed);
    [BetaUAV2, beta2Done] = FollowPathOneStep(BetaUAV2, deltaT, params.uavSpeed);

    %% Communication: Beta UAVs to Alpha

    Beta12AlphaMessage = Beta2AlphaCommunication(BetaUAV1); %#ok<NASGU>
    Beta22AlphaMessage = Beta2AlphaCommunication(BetaUAV2); %#ok<NASGU>

    %% Communication: Alpha to Operator / GUI

    Alpha2OperatorMessage = Alpha2OperatorCommunication(AlphaUAV, BetaUAV1, BetaUAV2);

    if mod(step, 20) == 0
        UpdateOperatorUAV(Alpha2OperatorMessage);
    end

    %% Update visualization

    set(hAlpha, ...
        "XData", AlphaUAV.Positions(1,end), ...
        "YData", AlphaUAV.Positions(2,end), ...
        "ZData", AlphaUAV.Positions(3,end));

    set(hBeta1, ...
        "XData", BetaUAV1.Positions(1,end), ...
        "YData", BetaUAV1.Positions(2,end), ...
        "ZData", BetaUAV1.Positions(3,end));

    set(hBeta2, ...
        "XData", BetaUAV2.Positions(1,end), ...
        "YData", BetaUAV2.Positions(2,end), ...
        "ZData", BetaUAV2.Positions(3,end));

    drawnow limitrate;

    %% Finish condition

    FinishSimulation = alphaDone && beta1Done && beta2Done;

    step = step + 1;

    % This controls only visual animation delay.
    % Smaller value makes the figure animation faster.
    pause(0.01);
end

if FinishSimulation
    disp("Simulation finished successfully.");
else
    warning("Simulation stopped because maxSteps was reached before all UAVs arrived.");
end

%% Save output data for GUI or post-processing

simData = BuildSimDataFromUAVs(AlphaUAV, BetaUAV1, BetaUAV2);

save("swarm_navigation_simData.mat", "simData", "Map", "params", "missionStart", "missionGoal");

disp("swarm_navigation_simData.mat saved.");