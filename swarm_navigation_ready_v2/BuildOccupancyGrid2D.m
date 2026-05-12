function [occGrid, info] = BuildOccupancyGrid2D(Map, resolution, inflateRadius, altitude)
% BuildOccupancyGrid2D
% Converts building footprints into a 2D occupancy grid.
%
% Important:
% Buildings are always treated as horizontal no-fly zones.
% Even if UAV altitude is higher than the building height, the planner
% does not allow the path to pass through building footprints.
%
% This prevents the path from crossing through buildings in top-down view.

    %#ok<INUSD>
    % altitude is kept in the function signature for compatibility,
    % but it is not used to ignore buildings.

    xVals = Map.xMin:resolution:Map.xMax;
    yVals = Map.yMin:resolution:Map.yMax;

    nRows = numel(yVals);
    nCols = numel(xVals);

    occGrid = false(nRows, nCols);

    for b = 1:size(Map.Buildings,1)
        building = Map.Buildings(b,:);

        % Building footprint
        xMin = building(1) - inflateRadius;
        xMax = building(2) + inflateRadius;
        yMin = building(3) - inflateRadius;
        yMax = building(4) + inflateRadius;

        colMask = xVals >= xMin & xVals <= xMax;
        rowMask = yVals >= yMin & yVals <= yMax;

        occGrid(rowMask, colMask) = true;
    end

    info.xVals = xVals;
    info.yVals = yVals;
    info.resolution = resolution;
    info.xMin = Map.xMin;
    info.yMin = Map.yMin;
    info.nRows = nRows;
    info.nCols = nCols;
end