function paths = run_voronoi_coverage_3uav(startPositions, coveragePoints)
% run_voronoi_coverage_3uav
% Assigns each coverage point to the nearest UAV start position.
% Each UAV scans its own Voronoi-like region.

numUAV = size(startPositions,1);

regions = cell(1,numUAV);
paths = cell(1,numUAV);

% Assign coverage points to nearest UAV seed
for p = 1:size(coveragePoints,1)
    point = coveragePoints(p,:);

    d = vecnorm(startPositions(:,1:3) - point, 2, 2);
    [~, assignedUAV] = min(d);

    regions{assignedUAV} = [regions{assignedUAV}; point];
end

% Each UAV visits its own region using structured scan ordering
for u = 1:numUAV
    regionPoints = regions{u};

    if isempty(regionPoints)
        paths{u} = startPositions(u,:);
        continue;
    end

    % Sort by x, then alternate y direction for sweep-like regional path
    uniqueX = unique(regionPoints(:,1));
    path = startPositions(u,:);

    for ix = 1:numel(uniqueX)
        xVal = uniqueX(ix);
        colPoints = regionPoints(regionPoints(:,1) == xVal, :);

        if mod(ix,2) == 1
            [~, order] = sort(colPoints(:,2), "ascend");
        else
            [~, order] = sort(colPoints(:,2), "descend");
        end

        colPoints = colPoints(order,:);
        path = [path; colPoints];
    end

    paths{u} = path;
end
end