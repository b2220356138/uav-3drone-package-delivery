function UpdateOperatorUAV(msg)
% UpdateOperatorUAV
% Console output. Later this can update GUI labels/tables.

    fprintf("\nOperator update: %s\n", string(msg.Timestamp));

    for i = 1:numel(msg.Drones)
        d = msg.Drones(i);
        fprintf("%s | pos=[%.2f %.2f %.2f] | battery=%.1f | temp=%.1f | status=%s\n", ...
            d.ID, d.Position(1), d.Position(2), d.Position(3), ...
            d.Battery, d.Temperature, d.Status);
    end
end
