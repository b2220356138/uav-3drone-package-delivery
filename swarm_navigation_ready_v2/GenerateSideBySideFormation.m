function [leftPath, rightPath] = GenerateSideBySideFormation(centerPath, spacing)
% GenerateSideBySideFormation
% Creates two side paths offset perpendicular to center path direction.
% Adjacent UAV distance from center is spacing.
% If you want total distance between beta drones = 2*spacing.

    N = size(centerPath,2);
    leftPath = zeros(size(centerPath));
    rightPath = zeros(size(centerPath));

    for i = 1:N
        if i < N
            dir = centerPath(1:2,i+1) - centerPath(1:2,i);
        else
            dir = centerPath(1:2,i) - centerPath(1:2,i-1);
        end

        if norm(dir) < 1e-6
            normal = [0;1];
        else
            dir = dir / norm(dir);
            normal = [-dir(2); dir(1)];
        end

        offset = spacing * normal;

        leftPath(:,i) = centerPath(:,i);
        rightPath(:,i) = centerPath(:,i);

        leftPath(1:2,i) = centerPath(1:2,i) + offset;
        rightPath(1:2,i) = centerPath(1:2,i) - offset;
    end
end
