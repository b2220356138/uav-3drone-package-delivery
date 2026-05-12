function PlotMap3D(Map)
% PlotMap3D
% Draws building prisms.

    for i = 1:size(Map.Buildings,1)
        b = Map.Buildings(i,:);
        DrawBuilding(b);
    end
end

function DrawBuilding(b)
    xMin = b(1); xMax = b(2);
    yMin = b(3); yMax = b(4);
    h = b(5);

    V = [
        xMin yMin 0
        xMax yMin 0
        xMax yMax 0
        xMin yMax 0
        xMin yMin h
        xMax yMin h
        xMax yMax h
        xMin yMax h
    ];

    F = [
        1 2 3 4
        5 6 7 8
        1 2 6 5
        2 3 7 6
        3 4 8 7
        4 1 5 8
    ];

    patch("Vertices",V,"Faces",F, ...
        "FaceColor",[0.6 0.6 0.6], ...
        "FaceAlpha",0.35, ...
        "EdgeColor",[0.2 0.2 0.2]);
end
