function xy = GridToWorld(rc, info)
% GridToWorld
% Converts grid [row col] to world [x;y].

    row = rc(1);
    col = rc(2);

    x = info.xVals(col);
    y = info.yVals(row);

    xy = [x; y];
end
