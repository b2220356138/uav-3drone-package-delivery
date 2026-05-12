function [occGrid, info] = BuildOccupancyFromPointCloud(points, mapBounds, resolution, inflateRadius)
% BuildOccupancyFromPointCloud
% Converts 3D point cloud into a 2D occupancy grid for A* path planning.
%
% Input:
%   points        : Nx3 point cloud [x y z]
%   mapBounds     : [xMin xMax yMin yMax]
%   resolution    : grid resolution in meters/cell
%   inflateRadius : safety inflation radius in meters
%
% Output:
%   occGrid       : logical occupancy grid
%   info          : grid metadata

    xMin = mapBounds(1);
    xMax = mapBounds(2);
    yMin = mapBounds(3);
    yMax = mapBounds(4);

    xVals = xMin:resolution:xMax;
    yVals = yMin:resolution:yMax;

    occGrid = false(numel(yVals), numel(xVals));

    % Filter likely obstacle points.
    % Very low points are often ground. Very high points may be irrelevant.
    zMin = 3;
    zMax = 60;

    valid = points(:,3) > zMin & points(:,3) < zMax;
    obstaclePoints = points(valid,:);

    for i = 1:size(obstaclePoints,1)
        x = obstaclePoints(i,1);
        y = obstaclePoints(i,2);

        col = round((x - xMin) / resolution) + 1;
        row = round((y - yMin) / resolution) + 1;

        if row >= 1 && row <= size(occGrid,1) && ...
           col >= 1 && col <= size(occGrid,2)
            occGrid(row,col) = true;
        end
    end

    % Inflate occupied cells for formation width and safety clearance.
    inflateCells = ceil(inflateRadius / resolution);

    if inflateCells > 0
        se = strel("disk", inflateCells);
        occGrid = imdilate(occGrid, se);
    end

    info.xVals = xVals;
    info.yVals = yVals;
    info.xMin = xMin;
    info.yMin = yMin;
    info.xMax = xMax;
    info.yMax = yMax;
    info.resolution = resolution;
    info.nRows = numel(yVals);
    info.nCols = numel(xVals);
end