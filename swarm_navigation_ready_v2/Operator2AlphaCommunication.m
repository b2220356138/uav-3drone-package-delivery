function msg = Operator2AlphaCommunication()
% Operator2AlphaCommunication
% Placeholder for GUI/operator command.
% In the future, GUI buttons can set these fields.

    msg.Command = "GO_TO_POINT";
    msg.StartPoint = [0;0;12];
    msg.GoalPoint = [95;85;12];

    % Optional building info could be added here.
    msg.Timestamp = datetime("now");
end
