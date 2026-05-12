function simData = BuildSimDataFromUAVs(AlphaUAV, BetaUAV1, BetaUAV2)
% BuildSimDataFromUAVs
% Creates GUI-compatible data structure.

    UAVs = {AlphaUAV, BetaUAV1, BetaUAV2};

    simData.numDrones = 3;
    simData.timeIndex = size(AlphaUAV.Positions,2);

    for i = 1:3
        UAV = UAVs{i};

        simData.drones(i).id = UAV.ID;
        simData.drones(i).x = UAV.Positions(1,end);
        simData.drones(i).y = UAV.Positions(2,end);
        simData.drones(i).z = UAV.Positions(3,end);
        simData.drones(i).role = UAV.Role;
        simData.drones(i).battery = UAV.Battery;
        simData.drones(i).temperature = UAV.Temperatures;
        simData.drones(i).status = UAV.Status;

        simData.drones(i).xTrajectory = UAV.Positions(1,:)';
        simData.drones(i).yTrajectory = UAV.Positions(2,:)';
        simData.drones(i).zTrajectory = UAV.Positions(3,:)';
    end
end
