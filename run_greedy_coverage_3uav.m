function export_multi_uav_video(paths, targets, area, algorithmName, fileName)
% export_multi_uav_video
% Creates an MP4 animation for 3-UAV algorithm paths.
%
% paths         : 1xN cell array, each cell is UAV path [x y z]
% targets       : Mx3 target points
% area          : area struct with xMin, xMax, yMin, yMax
% algorithmName : string, algorithm name
% fileName      : output video filename

    numUAV = numel(paths);

    if numUAV < 1
        error("paths must contain at least one UAV path.");
    end

    %% Smooth/interpolate each UAV path

    interpStep = 1.5;   % larger = faster video, smaller = smoother
    smoothPaths = cell(1,numUAV);
    maxSteps = 0;

    for u = 1:numUAV
        path = paths{u};

        if size(path,1) < 2
            smoothPaths{u} = path;
            maxSteps = max(maxSteps, size(path,1));
            continue;
        end

        smoothPath = [];

        for i = 1:size(path,1)-1
            p1 = path(i,:);
            p2 = path(i+1,:);

            dist = norm(p2 - p1);
            nSteps = max(2, ceil(dist / interpStep));

            segment = [
                linspace(p1(1), p2(1), nSteps)', ...
                linspace(p1(2), p2(2), nSteps)', ...
                linspace(p1(3), p2(3), nSteps)' ...
            ];

            if i > 1
                segment = segment(2:end,:);
            end

            smoothPath = [smoothPath; segment];
        end

        smoothPaths{u} = smoothPath;
        maxSteps = max(maxSteps, size(smoothPath,1));
    end

    %% Video writer

    if ~exist(fileparts(fileName), "dir") && strlength(string(fileparts(fileName))) > 0
        mkdir(fileparts(fileName));
    end

    v = VideoWriter(fileName, "MPEG-4");
    v.FrameRate = 20;
    open(v);

    %% Figure

    fig = figure("Name", algorithmName + " 3-UAV Simulation");
    hold on;
    grid on;
    axis equal;

    xlim([area.xMin-10 area.xMax+10]);
    ylim([area.yMin-10 area.yMax+10]);

    allZ = [];
    for u = 1:numUAV
        allZ = [allZ; paths{u}(:,3)];
    end
    zlim([0 max(allZ)+10]);

    xlabel("X / East");
    ylabel("Y / North");
    zlabel("Altitude");

    title(algorithmName + " 3-UAV Simulation");

    %% Area boundary

    plot3( ...
        [area.xMin area.xMax area.xMax area.xMin area.xMin], ...
        [area.yMin area.yMin area.yMax area.yMax area.yMin], ...
        [0 0 0 0 0], ...
        "k--", "LineWidth", 1.5);

    %% Targets

    plot3(targets(:,1), targets(:,2), targets(:,3), ...
        "kx", "MarkerSize", 10, "LineWidth", 2);

    %% Plot planned paths and initialize UAV markers

    uavMarkers = gobjects(1,numUAV);
    trailLines = gobjects(1,numUAV);

    for u = 1:numUAV
        path = paths{u};

        plot3(path(:,1), path(:,2), path(:,3), ...
            "--", "LineWidth", 1.2);

        firstPoint = smoothPaths{u}(1,:);

        uavMarkers(u) = plot3(firstPoint(1), firstPoint(2), firstPoint(3), ...
            "o", "MarkerSize", 10, "LineWidth", 2);

        trailLines(u) = plot3(firstPoint(1), firstPoint(2), firstPoint(3), ...
            "-", "LineWidth", 2);
    end

    legendEntries = ["Area Boundary", "Targets"];

    for u = 1:numUAV
        legendEntries(end+1) = "UAV" + u + " planned path";
        legendEntries(end+1) = "UAV" + u;
        legendEntries(end+1) = "UAV" + u + " traveled path";
    end

    legend(legendEntries, "Location", "bestoutside");

    view(3);

    %% Animation loop

    for k = 1:maxSteps
        for u = 1:numUAV
            sp = smoothPaths{u};

            idx = min(k, size(sp,1));
            current = sp(idx,:);

            uavMarkers(u).XData = current(1);
            uavMarkers(u).YData = current(2);
            uavMarkers(u).ZData = current(3);

            trailLines(u).XData = sp(1:idx,1);
            trailLines(u).YData = sp(1:idx,2);
            trailLines(u).ZData = sp(1:idx,3);
        end

        title(sprintf("%s 3-UAV Simulation | Step %d / %d", ...
            algorithmName, k, maxSteps));

        drawnow;

        frame = getframe(fig);
        writeVideo(v, frame);
    end

    close(v);

    fprintf("Video saved: %s\n", fileName);
end