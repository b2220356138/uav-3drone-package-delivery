function path = PlanRoadGraphPath(RoadGraph, startPoint, goalPoint)
% PlanRoadGraphPath
% Finds shortest path on a road graph using graph shortestpath.
%
% startPoint and goalPoint are snapped to nearest graph nodes.

nodes = RoadGraph.Nodes;
edges = RoadGraph.Edges;

% Snap start and goal to nearest graph nodes
dStart = vecnorm(nodes(:,1:3) - startPoint(:)', 2, 2);
dGoal  = vecnorm(nodes(:,1:3) - goalPoint(:)', 2, 2);

[~, startNode] = min(dStart);
[~, goalNode]  = min(dGoal);

% Edge weights = Euclidean distance
weights = zeros(size(edges,1),1);

for i = 1:size(edges,1)
    a = edges(i,1);
    b = edges(i,2);
    weights(i) = norm(nodes(a,:) - nodes(b,:));
end

G = graph(edges(:,1), edges(:,2), weights);

nodeRoute = shortestpath(G, startNode, goalNode);

if isempty(nodeRoute)
    path = [];
    return;
end

path = nodes(nodeRoute,:)';
end