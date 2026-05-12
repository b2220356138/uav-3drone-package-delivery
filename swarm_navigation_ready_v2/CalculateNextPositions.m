function MissionPlan = CalculateNextPositions(OperatorMsg, AlphaUAV, BetaUAV1, BetaUAV2, Map, params)
% CalculateNextPositions
% Alpha computes the center path and side-by-side formation paths.
% The center path is planned using A* on an inflated building map.
% Beta paths are generated as offsets from the centerline.

    startPoint = OperatorMsg.StartPoint(:);
    goalPoint  = OperatorMsg.GoalPoint(:);

    inflateRadius = params.buildingClearance + params.formationSpacing;
    centerPath = PlanAStarPath2D(startPoint, goalPoint, Map, params.gridResolution, inflateRadius, params.altitude);

    if isempty(centerPath)
        MissionPlan.Success = false;
        MissionPlan.Message = "A* could not find a collision-free path.";
        MissionPlan.AlphaPath = [];
        MissionPlan.Beta1Path = [];
        MissionPlan.Beta2Path = [];
        return;
    end

    centerPath = ResamplePathByDistance(centerPath, 1.0);

    [beta1Path, beta2Path] = GenerateSideBySideFormation(centerPath, params.formationSpacing);

    MissionPlan.Success = true;
    MissionPlan.Message = "Path planned successfully.";
    MissionPlan.AlphaPath = centerPath;
    MissionPlan.Beta1Path = beta1Path;
    MissionPlan.Beta2Path = beta2Path;

    % Next immediate positions are first motion targets.
    MissionPlan.AlphaPosition = centerPath(:,min(2,size(centerPath,2)));
    MissionPlan.Beta1Position = beta1Path(:,min(2,size(beta1Path,2)));
    MissionPlan.Beta2Position = beta2Path(:,min(2,size(beta2Path,2)));
end
