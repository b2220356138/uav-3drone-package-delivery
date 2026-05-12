    function path = PlanAStarPath2D(startPoint, goalPoint, Map, resolution, inflateRadius, altitude)
% PlanAStarPath2D
% Plans a shortest collision-free XY path around rectangular buildings
% using grid-based A*.

    [occGrid, gridInfo] = BuildOccupancyGrid2D(Map, resolution, inflateRadius, altitude);

    startRC = WorldToGrid(startPoint(1:2), gridInfo);
    goalRC  = WorldToGrid(goalPoint(1:2), gridInfo);

    if ~IsGridIndexValid(startRC, occGrid) || ~IsGridIndexValid(goalRC, occGrid)
        path = [];
        return;
    end

    if occGrid(startRC(1), startRC(2)) || occGrid(goalRC(1), goalRC(2))
        path = [];
        return;
    end

    gridPath = AStarGrid2D(occGrid, startRC, goalRC);

    if isempty(gridPath)
        path = [];
        return;
    end

    xy = zeros(2, size(gridPath,1));

    for i = 1:size(gridPath,1)
        xy(:,i) = GridToWorld(gridPath(i,:), gridInfo);
    end

    z = altitude * ones(1, size(xy,2));
    path = [xy; z];

    % Force exact start and goal.
    path(:,1) = [startPoint(1); startPoint(2); altitude];
    path(:,end) = [goalPoint(1); goalPoint(2); altitude];
end
