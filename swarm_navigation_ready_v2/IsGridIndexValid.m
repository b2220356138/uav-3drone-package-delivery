function valid = IsGridIndexValid(rc, grid)
% IsGridIndexValid
% Checks whether [row col] is inside the grid.

    valid = rc(1) >= 1 && rc(1) <= size(grid,1) && ...
            rc(2) >= 1 && rc(2) <= size(grid,2);
end
