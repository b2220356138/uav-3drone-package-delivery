function coveragePoints = generate_coverage_points(area, altitude, spacing)
% generate_coverage_points
% Generates grid-based coverage points inside the mission area.

[X, Y] = meshgrid(area.xMin:spacing:area.xMax, ...
    area.yMin:spacing:area.yMax);

coveragePoints = [X(:), Y(:), altitude * ones(numel(X),1)];
end