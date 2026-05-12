# Swarm Drone A-to-B Formation Navigation

This package contains a clean MATLAB implementation of 3-UAV formation navigation.

## What it does

The simulation:

1. Generates a 3D building map.
2. Initializes 3 UAVs:
   - Alpha: leader / center
   - Beta1: left wing
   - Beta2: right wing
3. Receives an operator command from point A to point B.
4. Plans the shortest safe center path using A*.
5. Inflates buildings so the side drones do not hit buildings.
6. Generates side-by-side formation paths.
7. Moves all 3 drones along the path.
8. Exports a GUI-compatible `simData` structure.
9. Converts the trajectories into Simulation 3D-compatible signals.
10. Creates a `Swarm3DViewer.slx` model with 3 Simulation 3D UAV Vehicle blocks.

---

## Required MATLAB Add-Ons

Recommended:

- MATLAB
- Simulink
- UAV Toolbox
- UAV Toolbox Interface for Unreal Engine Projects
- Simulink 3D Animation
- Robotics System Toolbox

---

## Run the MATLAB Figure Simulation

Open MATLAB and go to this folder:

```matlab
cd("C:\path\to\swarm_navigation_ready_v2")
```

Run:

```matlab
Main_SwarmNavigation
```

This creates a MATLAB 3D figure with buildings, paths, and moving drones.

It also creates:

```text
swarm_navigation_simData.mat
```

---

## Prepare Simulation 3D Signals

After running `Main_SwarmNavigation`, run:

```matlab
prepareSwarm3DSignals
```

This creates:

```text
swarm_3d_signals.mat
```

and these workspace variables:

```matlab
uav1TranslationTS
uav2TranslationTS
uav3TranslationTS
uav1RotationTS
uav2RotationTS
uav3RotationTS
swarm3DStopTime
```

---

## Create and Run the Simulation 3D Viewer

Run:

```matlab
createSwarm3DViewer
```

Then:

```matlab
sim("Swarm3DViewer")
```

If the viewer closes too quickly:

```matlab
set_param("Swarm3DViewer","StopTime",num2str(swarm3DStopTime + 10))
sim("Swarm3DViewer")
```

---

## Full Command Sequence

Use this sequence after opening MATLAB:

```matlab
cd("C:\path\to\swarm_navigation_ready_v2")

Main_SwarmNavigation
prepareSwarm3DSignals
createSwarm3DViewer
sim("Swarm3DViewer")
```

If `Swarm3DViewer.slx` already exists:

```matlab
cd("C:\path\to\swarm_navigation_ready_v2")

Main_SwarmNavigation
prepareSwarm3DSignals
open_system("Swarm3DViewer.slx")
set_param("Swarm3DViewer","StopTime",num2str(swarm3DStopTime + 10))
sim("Swarm3DViewer")
```

---

## Change A and B Points

Edit `Main_SwarmNavigation.m`:

```matlab
Operator2AlphaMessage.StartPoint = [0; 0; params.altitude];
Operator2AlphaMessage.GoalPoint  = [100; 95; params.altitude];
```

---

## Change Formation Distance

Edit `Main_SwarmNavigation.m`:

```matlab
params.formationSpacing = 4.0;
```

This means:

```text
Alpha-to-Beta1 distance = 4 m
Alpha-to-Beta2 distance = 4 m
Beta1-to-Beta2 distance = 8 m
```

---

## Change Buildings

Edit `GenerateMap.m`:

```matlab
Map.Buildings = [
    xMin xMax yMin yMax height
];
```

Each row defines one rectangular building.

---

## Simulation 3D Viewer Controls

Click inside the Simulation 3D Viewer window.

Typical controls:

```text
Right mouse + W  -> move forward
Right mouse + S  -> move backward / zoom out
Right mouse + A  -> move left
Right mouse + D  -> move right
Right mouse + Q  -> move down
Right mouse + E  -> move up
Mouse movement   -> rotate camera
Mouse wheel      -> zoom in/out
```

---

## Notes

The current `Swarm3DViewer.slx` uses the default Simulation 3D scene.

If a specific UAV Package Delivery city scene is required, copy the Scene Configuration settings from the UAV Package Delivery photorealistic example into:

```text
Swarm3DViewer/Simulation 3D Scene Configuration
```
