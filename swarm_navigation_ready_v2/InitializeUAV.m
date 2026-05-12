function UAV = InitializeUAV(id, position, velocity, role)
% InitializeUAV
% Creates a UAV state struct.

    UAV.ID = string(id);
    UAV.Role = string(role);

    UAV.Positions = position(:);
    UAV.Velocities = velocity(:);

    UAV.Temperatures = 30;
    UAV.Battery = 100;

    UAV.Path = [];
    UAV.PathIndex = 1;

    UAV.Status = "Ready";
end
