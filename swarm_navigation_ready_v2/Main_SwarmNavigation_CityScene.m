clear; close all; clc;

% Main_SwarmNavigation_CityScene
% 3-UAV formation navigation using a road graph calibrated for
% UAV Package Delivery Simulation 3D city scene.

%% Parameters

deltaT = 0.01;

params.uavSpeed = 12.0;
params.formationSpacing = 4.0;   % Alpha-Beta distance = 4 m
params.altitude = 15.0;
params.maxSteps = 20000;

%% Road graph

RoadGraph = GenerateCitySceneRoadGraph();

%% Start and goal on the city road graph

startPoint = [-186; 105; params.altitude];
goalPoint  = [100; -15; params.altitude];

%% UAV initialization

AlphaUAV = InitializeUAV("Alpha", startPoint, [0;0;0], "Leader");
BetaUAV1 = InitializeUAV("Beta1", startPoint + [0;-params.formationSpacing;0], [0;0;0], "Left Wing");
BetaUAV2 = InitializeUAV("Beta2", startPoint + [0; params.formationSpacing;0], [0;0;0], "Right Wing");

%% Path planning on city road graph

centerPath = PlanRoadGraphPath(RoadGraph, startPoint, goalPoint);

if isempty(centerPath)
    error("No path found on city road graph.");
end

centerPath = ResamplePathByDistance(centerPath, 1.0);

[beta1Path, beta2Path] = GenerateSideBySideFormation(centerPath, params.formationSpacing);

AlphaUAV.Path = centerPath;
BetaUAV1.Path = beta1Path;
BetaUAV2.Path = beta2Path;

AlphaUAV.PathIndex = 1;
BetaUAV1.PathIndex = 1;
BetaUAV2.PathIndex = 1;

%% Plot road graph and paths

figure("Name","3-UAV City Scene Road Graph Navigation");
hold on; grid on; axis equal;
title("3-UAV Navigation on City Scene Road Graph");
xlabel("East / X (m)");
ylabel("North / Y (m)");
zlabel("Up / Z (m)");
view(3);

nodes = RoadGraph.Nodes;
edges = RoadGraph.Edges;

for i = 1:size(edges,1)
    a = edges(i,1);
    b = edges(i,2);
    plot3(nodes([a b],1), nodes([a b],2), nodes([a b],3), "k--");
end

plot3(nodes(:,1), nodes(:,2), nodes(:,3), "ko", "MarkerSize", 5);

plot3(centerPath(1,:), centerPath(2,:), centerPath(3,:), "b-", "LineWidth", 2);
plot3(beta1Path(1,:), beta1Path(2,:), beta1Path(3,:), "r-", "LineWidth", 1.5);
plot3(beta2Path(1,:), beta2Path(2,:), beta2Path(3,:), "g-", "LineWidth", 1.5);

hAlpha = plot3(AlphaUAV.Positions(1,end), AlphaUAV.Positions(2,end), AlphaUAV.Positions(3,end), "bo", "MarkerSize", 10, "LineWidth", 2);
hBeta1 = plot3(BetaUAV1.Positions(1,end), BetaUAV1.Positions(2,end), BetaUAV1.Positions(3,end), "ro", "MarkerSize", 10, "LineWidth", 2);
hBeta2 = plot3(BetaUAV2.Positions(1,end), BetaUAV2.Positions(2,end), BetaUAV2.Positions(3,end), "go", "MarkerSize", 10, "LineWidth", 2);

legend("Road graph", "Road nodes", "Alpha path", "Beta1 path", "Beta2 path", "Alpha", "Beta1", "Beta2");

%% Simulation loop

FinishSimulation = false;
step = 1;

while ~FinishSimulation && step <= params.maxSteps

    [AlphaUAV, alphaDone] = FollowPathOneStep(AlphaUAV, deltaT, params.uavSpeed);
    [BetaUAV1, beta1Done] = FollowPathOneStep(BetaUAV1, deltaT, params.uavSpeed);
    [BetaUAV2, beta2Done] = FollowPathOneStep(BetaUAV2, deltaT, params.uavSpeed);

    set(hAlpha, "XData", AlphaUAV.Positions(1,end), "YData", AlphaUAV.Positions(2,end), "ZData", AlphaUAV.Positions(3,end));
    set(hBeta1, "XData", BetaUAV1.Positions(1,end), "YData", BetaUAV1.Positions(2,end), "ZData", BetaUAV1.Positions(3,end));
    set(hBeta2, "XData", BetaUAV2.Positions(1,end), "YData", BetaUAV2.Positions(2,end), "ZData", BetaUAV2.Positions(3,end));

    drawnow limitrate;

    FinishSimulation = alphaDone && beta1Done && beta2Done;
    step = step + 1;
    pause(0.01);
end

disp("City scene road graph simulation finished.");

simData = BuildSimDataFromUAVs(AlphaUAV, BetaUAV1, BetaUAV2);

save("swarm_navigation_simData.mat", "simData", "RoadGraph", "params");