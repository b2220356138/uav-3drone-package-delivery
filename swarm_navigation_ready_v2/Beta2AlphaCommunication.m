function msg = Beta2AlphaCommunication(BetaUAV)
% Beta2AlphaCommunication
% Beta UAV reports state to Alpha.

    msg.ID = BetaUAV.ID;
    msg.Position = BetaUAV.Positions(:,end);
    msg.Velocity = BetaUAV.Velocities(:,end);
    msg.Temperature = BetaUAV.Temperatures;
    msg.Battery = BetaUAV.Battery;
    msg.Status = BetaUAV.Status;
    msg.Timestamp = datetime("now");
end
