function newPath = ResamplePathByDistance(path, step)
% ResamplePathByDistance
% Resamples a 3xN path approximately every step meters.

    if size(path,2) < 2
        newPath = path;
        return;
    end

    newPath = path(:,1);

    for i = 1:size(path,2)-1
        p1 = path(:,i);
        p2 = path(:,i+1);
        d = norm(p2 - p1);

        n = max(2, ceil(d/step));

        for k = 2:n
            alpha = (k-1)/(n-1);
            p = (1-alpha)*p1 + alpha*p2;
            newPath(:,end+1) = p;
        end
    end
end
