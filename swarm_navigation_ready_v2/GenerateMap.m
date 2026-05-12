function Map = GenerateMap()
% GenerateMap
% City-like building map for 3-UAV formation navigation.
%
% This map is designed to look more like an urban street layout:
% - multiple building blocks
% - horizontal main road
% - vertical side roads
% - enough road width for 3 UAV side-by-side formation
%
% Coordinate convention:
% x = forward / east direction
% y = lateral / north direction
% z = altitude

Map.xMin = -80;
Map.xMax = 80;
Map.yMin = -60;
Map.yMax = 60;
Map.zMin = 0;
Map.zMax = 45;

% Building format:
% [xMin xMax yMin yMax height]
%
% Road layout:
% - Main horizontal road: roughly y = -18 to +18
% - Vertical roads/gaps between building columns:
%   x = -50 to -30
%   x = -10 to +10
%   x = +30 to +50
%
% This creates a more complex city-like map than a single corridor.

Map.Buildings = [
    % Lower row buildings
    -75 -55  -55 -22  28
    -30 -12  -55 -22  35
    12  30  -55 -22  30
    52  75  -55 -22  32

    % Upper row buildings
    -75 -55   22  55  28
    -30 -12   22  55  34
    12  30   22  55  31
    52  75   22  55  36

    % Additional small blocks to make path planning less trivial
    -70 -58   -5  12  20
    58  70   -8  10  22
    ];

Map.Name = "City-like multi-corridor building map";
end