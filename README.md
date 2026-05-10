3. Run the 3-UAV Coverage Algorithm Comparison

Go to the coverage algorithm folder:

cd("scripts\algorithm_comparison_3uav_coverage")

Run the main comparison script:

main_coverage_comparison_3uav

This generates:

coverage_trajectory_comparison_2d.png
coverage_trajectory_comparison_3d.png
coverage_total_path_length.png
coverage_mission_time.png
coverage_energy.png
coverage_turn_count.png
coverage_percentage.png
coverage_compute_time.png
coverage_compute_time_logscale.png
coverage_comparison_3uav_results.mat

The algorithms compared are:

Greedy Coverage
Voronoi Coverage
ACO Coverage
Lawnmower Coverage

All algorithms use the same:

mission area
coverage grid
3 UAV start positions
altitude
sensor radius
speed assumption
4. Generate 3-UAV Coverage Videos

If the videos are not already generated, run:

cd("scripts\algorithm_comparison_3uav_coverage")
load("coverage_comparison_3uav_results.mat")

Then run:

if ~exist("videos","dir")
    mkdir("videos")
end

export_multi_uav_video(paths.Greedy, coveragePoints, area, ...
    "Greedy Coverage", fullfile("videos","greedy_3uav_coverage.mp4"));

export_multi_uav_video(paths.Voronoi, coveragePoints, area, ...
    "Voronoi Coverage", fullfile("videos","voronoi_3uav_coverage.mp4"));

export_multi_uav_video(paths.ACO, coveragePoints, area, ...
    "ACO Coverage", fullfile("videos","aco_3uav_coverage.mp4"));

export_multi_uav_video(paths.Lawnmower, coveragePoints, area, ...
    "Lawnmower Coverage", fullfile("videos","lawnmower_3uav_coverage.mp4"));

The generated videos are saved in:

scripts/algorithm_comparison_3uav_coverage/videos/

Expected files:

greedy_3uav_coverage.mp4
voronoi_3uav_coverage.mp4
aco_3uav_coverage.mp4
lawnmower_3uav_coverage.mp4
5. Run the GUI-Compatible Telemetry Data

The GUI-compatible data file is:

results/three_uav_gui_simData.mat

Load it in MATLAB:

load("results\three_uav_gui_simData.mat")

The GUI can read drone data using:

simData.drones(i).id
simData.drones(i).x
simData.drones(i).y
simData.drones(i).role
simData.drones(i).battery
simData.drones(i).temperature
simData.drones(i).status

Each drone also includes trajectory fields:

simData.drones(i).xTrajectory
simData.drones(i).yTrajectory
simData.drones(i).zTrajectory

To update telemetry at a specific time index:

simData = updateDroneTelemetry(simData, 1);

Example:

load("results\three_uav_gui_simData.mat")

simData = updateDroneTelemetry(simData, 50);

simData.drones(1)
simData.drones(2)
simData.drones(3)

The updateDroneTelemetry.m function updates:

x
y
z
role
battery
temperature
status

It also ignores invalid or NaN trajectory points and uses the nearest valid position.

6. Open the Full 3-UAV Simulink Model

The main full 3-UAV model is:

models/uavPackageDelivery_3UAV_full_sensors_v2.slx

To open it:

addpath(genpath(pwd))

open_system("models\uavPackageDelivery_3UAV_full_sensors_v2.slx")

Before simulation, define the required variables:

useQGC = false;
isPhotoRealisticSim = 0;
guidanceType = 1;
plantModelFi = 0;
useHeading = 0;
startFlightTime = 5;
showLidarPointCloud = 0;
showVideoViewer = 0;

assignin("base","useQGC",useQGC);
assignin("base","isPhotoRealisticSim",isPhotoRealisticSim);
assignin("base","guidanceType",guidanceType);
assignin("base","plantModelFi",plantModelFi);
assignin("base","useHeading",useHeading);
assignin("base","startFlightTime",startFlightTime);
assignin("base","showLidarPointCloud",showLidarPointCloud);
assignin("base","showVideoViewer",showVideoViewer);

Run a short test first:

mdl = "uavPackageDelivery_3UAV_full_sensors_v2";

set_param(mdl,"StopTime","5")
sim(mdl)

If that works, increase slowly:

set_param(mdl,"StopTime","10")
sim(mdl)

Then:

set_param(mdl,"StopTime","20")
sim(mdl)

Do not immediately run long simulations. Start with short stop times.

7. Run the High-Fidelity Dynamics Test

The high-fidelity test model is:

models/uavPackageDelivery_3UAV_high_fidelity_test.slx

Open it:

open_system("models\uavPackageDelivery_3UAV_high_fidelity_test.slx")

Set high-fidelity dynamics:

mdl = "uavPackageDelivery_3UAV_high_fidelity_test";

useQGC = false;
isPhotoRealisticSim = 0;
guidanceType = 1;
plantModelFi = 1;
useHeading = 0;
startFlightTime = 100;
showLidarPointCloud = 0;
showVideoViewer = 0;

assignin("base","useQGC",useQGC);
assignin("base","isPhotoRealisticSim",isPhotoRealisticSim);
assignin("base","guidanceType",guidanceType);
assignin("base","plantModelFi",plantModelFi);
assignin("base","useHeading",useHeading);
assignin("base","startFlightTime",startFlightTime);
assignin("base","showLidarPointCloud",showLidarPointCloud);
assignin("base","showVideoViewer",showVideoViewer);

Run a very short test:

set_param(mdl,"StopTime","0.5")
sim(mdl)

Then increase gradually:

set_param(mdl,"StopTime","1")
sim(mdl)
8. Photorealistic 3D Visualization Test

The experimental photorealistic model is:

models/uavPackageDelivery_3UAV_photo3D_realStates.slx

Open it:

open_system("models\uavPackageDelivery_3UAV_photo3D_realStates.slx")

Set photorealistic and high-fidelity variables:

mdl = "uavPackageDelivery_3UAV_photo3D_realStates";

useQGC = false;
isPhotoRealisticSim = 2;
guidanceType = 1;
plantModelFi = 1;
useHeading = 0;
startFlightTime = 100;
showLidarPointCloud = 0;
showVideoViewer = 0;

assignin("base","useQGC",useQGC);
assignin("base","isPhotoRealisticSim",isPhotoRealisticSim);
assignin("base","guidanceType",guidanceType);
assignin("base","plantModelFi",plantModelFi);
assignin("base","useHeading",useHeading);
assignin("base","startFlightTime",startFlightTime);
assignin("base","showLidarPointCloud",showLidarPointCloud);
assignin("base","showVideoViewer",showVideoViewer);

Run a short visualization test:

set_param(mdl,"StopTime","1")
sim(mdl)

The Simulation 3D Viewer should open.

If the window closes too quickly, increase the stop time while keeping startFlightTime = 100:

set_param(mdl,"StopTime","20")
sim(mdl)

This keeps the scene open for camera adjustment while preventing the mission from starting.

9. Simulation 3D Viewer Camera Controls

After the Simulation 3D Viewer opens, click inside the viewer window.

Typical camera controls:
Mouse movement   -> rotate view
Mouse wheel      -> zoom in / out


11. Important Notes

The photorealistic Simulation 3D environment supports only one co-simulation session at a time.

Because of this limitation, the project uses:

one Simulation 3D Engine
multiple UAV actors

rather than starting a separate Simulation 3D Engine for each UAV.

If the following error appears:

Only one co-simulation session allowed

close all Simulation 3D Viewer windows, restart MATLAB, and rerun only one photorealistic model at a time.

12. Recommended Execution Order

For a new user, run in this order:

addpath(genpath(pwd))

Then run the coverage algorithm comparison:

cd("scripts\algorithm_comparison_3uav_coverage")
main_coverage_comparison_3uav

Then generate or check videos:

dir("videos")

Then test the GUI data:

cd("..\..")
load("results\three_uav_gui_simData.mat")
simData = updateDroneTelemetry(simData, 1);
simData.drones(1)

Then test the Simulink 3-UAV model:

open_system("models\uavPackageDelivery_3UAV_full_sensors_v2.slx")

useQGC = false;
isPhotoRealisticSim = 0;
guidanceType = 1;
plantModelFi = 0;
useHeading = 0;
startFlightTime = 5;
showLidarPointCloud = 0;
showVideoViewer = 0;

assignin("base","useQGC",useQGC);
assignin("base","isPhotoRealisticSim",isPhotoRealisticSim);
assignin("base","guidanceType",guidanceType);
assignin("base","plantModelFi",plantModelFi);
assignin("base","useHeading",useHeading);
assignin("base","startFlightTime",startFlightTime);
assignin("base","showLidarPointCloud",showLidarPointCloud);
assignin("base","showVideoViewer",showVideoViewer);

set_param("uavPackageDelivery_3UAV_full_sensors_v2","StopTime","5")
sim("uavPackageDelivery_3UAV_full_sensors_v2")
13. Main Output Files

Algorithm figures:

results/figures/

Algorithm videos:

results/videos/

GUI data:

results/three_uav_gui_simData.mat

Main models:

models/

Algorithm scripts:

scripts/algorithm_comparison_3uav_coverage/





########################################################################################################################################################

function paths = run_voronoi_coverage_3uav(startPositions, coveragePoints)
% run_voronoi_coverage_3uav
% Assigns each coverage point to the nearest UAV start position.
% Each UAV scans its own Voronoi-like region.

numUAV = size(startPositions,1);

regions = cell(1,numUAV);
paths = cell(1,numUAV);

% Assign coverage points to nearest UAV seed
for p = 1:size(coveragePoints,1)
    point = coveragePoints(p,:);

    d = vecnorm(startPositions(:,1:3) - point, 2, 2);
    [~, assignedUAV] = min(d);

    regions{assignedUAV} = [regions{assignedUAV}; point];
end

% Each UAV visits its own region using structured scan ordering
for u = 1:numUAV
    regionPoints = regions{u};

    if isempty(regionPoints)
        paths{u} = startPositions(u,:);
        continue;
    end

    % Sort by x, then alternate y direction for sweep-like regional path
    uniqueX = unique(regionPoints(:,1));
    path = startPositions(u,:);

    for ix = 1:numel(uniqueX)
        xVal = uniqueX(ix);
        colPoints = regionPoints(regionPoints(:,1) == xVal, :);

        if mod(ix,2) == 1
            [~, order] = sort(colPoints(:,2), "ascend");
        else
            [~, order] = sort(colPoints(:,2), "descend");
        end

        colPoints = colPoints(order,:);
        path = [path; colPoints];
    end

    paths{u} = path;
end
end
