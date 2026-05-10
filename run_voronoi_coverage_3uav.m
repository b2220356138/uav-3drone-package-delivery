clear
clc
close all

%% ============================================================
% 3-UAV Coverage Algorithm Comparison
% Algorithms:
% 1) Greedy Coverage
% 2) Voronoi Coverage
% 3) ACO Coverage
% 4) Lawnmower Coverage
% ============================================================

%% Scenario Settings

area.xMin = 0;
area.xMax = 100;
area.yMin = 0;
area.yMax = 100;

altitude = 15;
uavSpeed = 5;              % m/s
coverageSpacing = 10;      % coverage grid spacing
sensorRadius = 8;          % sensor footprint radius

% 3 UAV start positions
startPositions = [
    10 10 altitude
    90 10 altitude
    50 90 altitude
    ];

% Same coverage points for all algorithms
coveragePoints = generate_coverage_points(area, altitude, coverageSpacing);

%% Generate coverage paths

tic
paths.Greedy = run_greedy_coverage_3uav(startPositions, coveragePoints);
computeTime.Greedy = toc;

tic
paths.Voronoi = run_voronoi_coverage_3uav(startPositions, coveragePoints);
computeTime.Voronoi = toc;

tic
paths.ACO = run_aco_coverage_3uav(startPositions, coveragePoints);
computeTime.ACO = toc;

tic
paths.Lawnmower = run_lawnmower_coverage_3uav(area, altitude, coverageSpacing, startPositions);
computeTime.Lawnmower = toc;

%% Compute metrics

algorithmNames = ["Greedy", "Voronoi", "ACO", "Lawnmower"];

for i = 1:numel(algorithmNames)
    name = char(algorithmNames(i));

    metrics.(name) = compute_coverage_metrics( ...
        paths.(name), ...
        area, ...
        coveragePoints, ...
        sensorRadius, ...
        uavSpeed, ...
        computeTime.(name));
end

%% Plot trajectories and metrics

plot_coverage_trajectories(paths, coveragePoints, area, startPositions);
plot_coverage_metric_charts(metrics, algorithmNames);

%% Save results

save("coverage_comparison_3uav_results.mat", ...
    "paths", ...
    "metrics", ...
    "algorithmNames", ...
    "coveragePoints", ...
    "area", ...
    "startPositions", ...
    "sensorRadius", ...
    "coverageSpacing")

disp("3-UAV coverage comparison completed successfully.")