function path = AStarGrid2D(occGrid, startRC, goalRC)
% AStarGrid2D
% 8-connected A* search on a logical occupancy grid.
% occGrid(row,col) = true means occupied.

    nRows = size(occGrid,1);
    nCols = size(occGrid,2);

    startIdx = sub2ind(size(occGrid), startRC(1), startRC(2));
    goalIdx  = sub2ind(size(occGrid), goalRC(1), goalRC(2));

    gScore = inf(nRows, nCols);
    fScore = inf(nRows, nCols);
    cameFrom = zeros(nRows, nCols);

    openSet = false(nRows, nCols);
    closedSet = false(nRows, nCols);

    gScore(startRC(1), startRC(2)) = 0;
    fScore(startRC(1), startRC(2)) = Heuristic(startRC, goalRC);
    openSet(startRC(1), startRC(2)) = true;

    neighbors = [
        -1  0
         1  0
         0 -1
         0  1
        -1 -1
        -1  1
         1 -1
         1  1
    ];

    while any(openSet(:))
        openIdx = find(openSet);
        [~, bestLocal] = min(fScore(openIdx));
        currentIdx = openIdx(bestLocal);

        [cr, cc] = ind2sub(size(occGrid), currentIdx);
        currentRC = [cr cc];

        if currentIdx == goalIdx
            path = ReconstructPath(cameFrom, currentIdx, size(occGrid));
            return;
        end

        openSet(cr, cc) = false;
        closedSet(cr, cc) = true;

        for k = 1:size(neighbors,1)
            nr = cr + neighbors(k,1);
            nc = cc + neighbors(k,2);

            if nr < 1 || nr > nRows || nc < 1 || nc > nCols
                continue;
            end

            if occGrid(nr,nc) || closedSet(nr,nc)
                continue;
            end

            stepCost = norm(neighbors(k,:));
            tentativeG = gScore(cr,cc) + stepCost;

            if ~openSet(nr,nc)
                openSet(nr,nc) = true;
            elseif tentativeG >= gScore(nr,nc)
                continue;
            end

            cameFrom(nr,nc) = currentIdx;
            gScore(nr,nc) = tentativeG;
            fScore(nr,nc) = tentativeG + Heuristic([nr nc], goalRC);
        end
    end

    path = [];
end

function h = Heuristic(a, b)
    h = norm(double(a) - double(b));
end

function path = ReconstructPath(cameFrom, currentIdx, gridSize)
    idxPath = currentIdx;

    while cameFrom(currentIdx) ~= 0
        currentIdx = cameFrom(currentIdx);
        idxPath = [currentIdx; idxPath];
    end

    path = zeros(numel(idxPath), 2);

    for i = 1:numel(idxPath)
        [r,c] = ind2sub(gridSize, idxPath(i));
        path(i,:) = [r c];
    end
end
