function msg = Alpha2OperatorCommunication(AlphaUAV, BetaUAV1, BetaUAV2)
% Alpha2OperatorCommunication
% Alpha reports all UAV states to the operator/GUI.

    msg.Drones(1) = PackDroneState(AlphaUAV);
    msg.Drones(2) = PackDroneState(BetaUAV1);
    msg.Drones(3) = PackDroneState(BetaUAV2);
    msg.Timestamp = datetime("now");
end

function d = PackDroneState(UAV)
    d.ID = UAV.ID;
    d.Role = UAV.Role;
    d.Position = UAV.Positions(:,end);
    d.Velocity = UAV.Velocities(:,end);
    d.Temperature = UAV.Temperatures;
    d.Battery = UAV.Battery;
    d.Status = UAV.Status;
end
