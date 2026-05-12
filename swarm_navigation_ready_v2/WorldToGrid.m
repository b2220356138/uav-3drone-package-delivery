function rc = WorldToGrid(xy, info)
% WorldToGrid
% Converts world [x;y] to grid [row col].

    x = xy(1);
    y = xy(2);

    col = round((x - info.xMin) / info.resolution) + 1;
    row = round((y - info.yMin) / info.resolution) + 1;

    rc = [row col];
end
