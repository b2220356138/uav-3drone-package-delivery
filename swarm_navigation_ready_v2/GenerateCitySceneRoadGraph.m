function RoadGraph = GenerateCitySceneRoadGraph()
% GenerateCitySceneRoadGraph
% Road graph calibrated for the UAV Package Delivery Simulation 3D city scene.
%
% Coordinates are Simulation 3D Viewer coordinates:
% x = East
% y = North
% z = Up
%
% These points are derived from the UAV Package Delivery baseMission
% coordinate pattern and converted from NED-like mission coordinates:
% [x, yMission, zMission] -> [x, -yMission, abs(zMission)].

z = 15;

% Main safe road corridor / centerline nodes
nodes = [
    -186.0   105.0   z
    -150.0   105.0   z
    -118.8   105.0   z
    -118.8    76.9   z
    -119.1    12.0   z
    -66.5    -5.4   z
    -35.2    -7.3   z
    20.0    -4.0   z
    56.8    -2.5   z
    100.0   -15.0   z
    140.0   -25.0   z
    170.0   -31.0   z
    ];

% Extra branch nodes to make city graph less trivial
extraNodes = [
    -118.8   130.0   z
    -118.8    40.0   z
    -66.5    30.0   z
    -35.2    35.0   z
    20.0    35.0   z
    56.8    30.0   z
    95.0    20.0   z
    ];

nodes = [nodes; extraNodes];

% Edges connect safe road segments.
% Main chain edges
edges = [
    1  2
    2  3
    3  4
    4  5
    5  6
    6  7
    7  8
    8  9
    9 10
    10 11
    11 12
    ];

% Branch edges
edges = [
    edges
    3 13
    4 14
    6 15
    7 16
    8 17
    9 18
    10 19
    14 15
    15 16
    16 17
    17 18
    18 19
    ];

RoadGraph.Nodes = nodes;
RoadGraph.Edges = edges;
RoadGraph.Name = "UAV Package Delivery city road graph";
end