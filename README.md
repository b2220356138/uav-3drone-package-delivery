# 3-UAV Package Delivery, Coverage Algorithms, GUI Data, and High-Fidelity Visualization

This repository extends the MATLAB UAV Package Delivery example into a 3-UAV simulation and algorithm comparison project.

The project includes:

- 3-UAV Simulink models
- Separate UAV dynamics for UAV1, UAV2, and UAV3
- Separate Ground Control blocks
- Separate On Board Computer blocks
- Experimental external sensor and photorealistic visualization pipelines
- 3-UAV coverage comparison using Greedy, Voronoi, ACO, and Lawnmower algorithms
- Trajectory plots
- Metric comparison charts
- MP4 simulation videos
- GUI-compatible `simData` telemetry structure

---

## 1. Required MATLAB Add-Ons

Install the following MATLAB products/add-ons before running the project:

- MATLAB
- Simulink
- UAV Toolbox
- UAV Toolbox Interface for Unreal Engine Projects
- Aerospace Toolbox
- Aerospace Blockset
- Navigation Toolbox
- Robotics System Toolbox
- Computer Vision Toolbox
- Image Processing Toolbox
- Simulink 3D Animation

For the photorealistic city scene, MATLAB must support Simulation 3D / Unreal-based visualization.

---

## 2. First Step After Downloading the Repository

Open MATLAB.

Go to the downloaded project folder. Example:

```matlab
cd("C:\path\to\uav_3drone_github_ready")
```

Add all project folders to the MATLAB path:

```matlab
addpath(genpath(pwd))
```

---

## 3. Run the 3-UAV Coverage Algorithm Comparison

Go to the coverage algorithm folder:

```matlab
cd("scripts\algorithm_comparison_3uav_coverage")
```

Run the main script:

```matlab
main_coverage_comparison_3uav
```

This generates trajectory plots, metric charts, result files, and videos.

Expected output files include:

```text
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
```

The compared algorithms are:

```text
Greedy Coverage
Voronoi Coverage
ACO Coverage
Lawnmower Coverage
```

All algorithms use the same:

```text
coverage area
coverage grid
3 UAV start positions
altitude
sensor radius
speed assumption
```

---

## 4. Generate 3-UAV Coverage Videos

If the videos are not already generated, run the following commands from the same folder:

```matlab
cd("scripts\algorithm_comparison_3uav_coverage")
load("coverage_comparison_3uav_results.mat")
```

Then run:

```matlab
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
```

Expected video outputs:

```text
videos/greedy_3uav_coverage.mp4
videos/voronoi_3uav_coverage.mp4
videos/aco_3uav_coverage.mp4
videos/lawnmower_3uav_coverage.mp4
```

If video generation is slow, open `export_multi_uav_video.m` and increase:

```matlab
interpStep = 1.5;
```

to:

```matlab
interpStep = 4.0;
```

or:

```matlab
interpStep = 6.0;
```

---

## 5. Run the GUI-Compatible Telemetry Data

The GUI-compatible data file is:

```text
results/three_uav_gui_simData.mat
```

Load it in MATLAB:

```matlab
load("results\three_uav_gui_simData.mat")
```

The GUI can read each drone using:

```matlab
simData.drones(i).id
simData.drones(i).x
simData.drones(i).y
simData.drones(i).role
simData.drones(i).battery
simData.drones(i).temperature
simData.drones(i).status
```

Each drone also contains trajectory fields:

```matlab
simData.drones(i).xTrajectory
simData.drones(i).yTrajectory
simData.drones(i).zTrajectory
```

To update telemetry at a specific time index:

```matlab
simData = updateDroneTelemetry(simData, 1);
```

Example:

```matlab
load("results\three_uav_gui_simData.mat")

simData = updateDroneTelemetry(simData, 50);

simData.drones(1)
simData.drones(2)
simData.drones(3)
```

The `updateDroneTelemetry.m` function updates:

```text
x
y
z
role
battery
temperature
status
```

It also ignores invalid or NaN trajectory points and uses the nearest valid position.

---

## 6. Open the Full 3-UAV Simulink Model

The main full 3-UAV model is:

```text
models/uavPackageDelivery_3UAV_full_sensors_v2.slx
```

Open it:

```matlab
addpath(genpath(pwd))

open_system("models\uavPackageDelivery_3UAV_full_sensors_v2.slx")
```

Before simulation, define the required variables:

```matlab
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
```

Run a short test first:

```matlab
mdl = "uavPackageDelivery_3UAV_full_sensors_v2";

set_param(mdl,"StopTime","5")
sim(mdl)
```

If that works, increase slowly:

```matlab
set_param(mdl,"StopTime","10")
sim(mdl)
```

Then:

```matlab
set_param(mdl,"StopTime","20")
sim(mdl)
```

Do not immediately run long simulations. Start with short stop times.

---

## 7. Run the High-Fidelity Dynamics Test

The high-fidelity test model is:

```text
models/uavPackageDelivery_3UAV_high_fidelity_test.slx
```

Open it:

```matlab
open_system("models\uavPackageDelivery_3UAV_high_fidelity_test.slx")
```

Set high-fidelity dynamics:

```matlab
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
```

Run a very short test:

```matlab
set_param(mdl,"StopTime","0.5")
sim(mdl)
```

Then increase gradually:

```matlab
set_param(mdl,"StopTime","1")
sim(mdl)
```

---

## 8. Photorealistic 3D Visualization Test

The experimental photorealistic model is:

```text
models/uavPackageDelivery_3UAV_photo3D_realStates.slx
```

Open it:

```matlab
open_system("models\uavPackageDelivery_3UAV_photo3D_realStates.slx")
```

Set photorealistic and high-fidelity variables:

```matlab
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
```

Run a short visualization test:

```matlab
set_param(mdl,"StopTime","1")
sim(mdl)
```

The Simulation 3D Viewer should open.

If the window closes too quickly, increase the stop time while keeping `startFlightTime = 100`:

```matlab
set_param(mdl,"StopTime","20")
sim(mdl)
```

This keeps the scene open for camera adjustment while preventing the mission from starting.

---

## 9. Simulation 3D Viewer Camera Controls

After the Simulation 3D Viewer opens, click inside the viewer window.

Typical controls:

```text
Right mouse + W  -> move forward
Right mouse + S  -> move backward / zoom out
Right mouse + A  -> move left
Right mouse + D  -> move right
Right mouse + Q  -> move down
Right mouse + E  -> move up
Mouse movement   -> rotate view
Mouse wheel      -> zoom in / out
```

For a better 3-drone view:

```text
Right mouse + S  -> move backward
Right mouse + E  -> move upward
```

---

## 10. Record the Simulation Screen

Use Windows screen recording:

```text
Win + Alt + R
```

This starts or stops recording using Xbox Game Bar.

Videos are usually saved in:

```text
C:\Users\<username>\Videos\Captures
```

---

## 11. Important Notes

The photorealistic Simulation 3D environment supports only one co-simulation session at a time.

Because of this limitation, the project uses:

```text
one Simulation 3D Engine
multiple UAV actors
```

instead of starting a separate Simulation 3D Engine for each UAV.

If the following error appears:

```text
Only one co-simulation session allowed
```

close all Simulation 3D Viewer windows, restart MATLAB, and rerun only one photorealistic model at a time.

---

## 12. Recommended Execution Order for a New User

From the repository root:

```matlab
addpath(genpath(pwd))
```

Run the coverage algorithm comparison:

```matlab
cd("scripts\algorithm_comparison_3uav_coverage")
main_coverage_comparison_3uav
```

Check videos:

```matlab
dir("videos")
```

Test GUI data:

```matlab
cd("..\..")
load("results\three_uav_gui_simData.mat")
simData = updateDroneTelemetry(simData, 1);
simData.drones(1)
```

Test the Simulink 3-UAV model:

```matlab
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
```

---

## 13. Main Output Files

Algorithm figures:

```text
results/figures/
```

Algorithm videos:

```text
results/videos/
```

GUI data:

```text
results/three_uav_gui_simData.mat
```

Main models:

```text
models/
```

Algorithm scripts:

```text
scripts/algorithm_comparison_3uav_coverage/
```
