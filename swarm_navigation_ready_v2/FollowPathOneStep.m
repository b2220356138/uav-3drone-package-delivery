function [UAV, done] = FollowPathOneStep(UAV, deltaT, speed)
% FollowPathOneStep
% Moves UAV toward the next waypoint by speed*deltaT.

    if isempty(UAV.Path)
        done = true;
        UAV.Status = "NoPath";
        return;
    end

    current = UAV.Positions(:,end);

    if UAV.PathIndex > size(UAV.Path,2)
        done = true;
        UAV.Status = "Arrived";
        UAV.Velocities(:,end+1) = [0;0;0];
        return;
    end

    target = UAV.Path(:, UAV.PathIndex);
    toTarget = target - current;
    dist = norm(toTarget);

    if dist < 0.2
        UAV.PathIndex = UAV.PathIndex + 1;

        if UAV.PathIndex > size(UAV.Path,2)
            newPos = target;
            newVel = [0;0;0];
            done = true;
            UAV.Status = "Arrived";
        else
            target = UAV.Path(:, UAV.PathIndex);
            toTarget = target - current;
            dist = norm(toTarget);
            step = min(speed*deltaT, dist);
            newPos = current + step * toTarget / max(dist, eps);
            newVel = (newPos - current) / deltaT;
            done = false;
            UAV.Status = "Flying";
        end
    else
        step = min(speed*deltaT, dist);
        newPos = current + step * toTarget / max(dist, eps);
        newVel = (newPos - current) / deltaT;
        done = false;
        UAV.Status = "Flying";
    end

    UAV.Positions(:,end+1) = newPos;
    UAV.Velocities(:,end+1) = newVel;

    UAV.Battery = max(0, UAV.Battery - 0.002*norm(newVel));
    UAV.Temperatures = UAV.Temperatures + 0.0005*norm(newVel);
end
