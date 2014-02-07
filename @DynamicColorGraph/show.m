function show(obj)
if isempty(obj.figureHandle) || ~obj.figureHandle.isvalid
    obj.createFigure();
end

centers = obj.nodeData();

% Add some external bounding points
val = (max(centers(:)) + 1) * 2;
p_ext = [centers; val val; val -val; -val -val; -val val];

% Create the actual patches in the voronoi diagram (i.e. not
% just the edges.
[v,c] = voronoin([p_ext(:,1) p_ext(:,2)]);

agents = obj.agents.values;

% Draw the patches in the voronoi
for i = 1:numel(c)
    if ~any(isinf(v(c{i},:))) % This still seems weird, aren't I sure that the invalid patches come last?
        if numel(obj.patches) >= i && obj.patches(i).isvalid
            % Update the patch
            obj.patches(i).Faces = 1:numel(c{i});
            obj.patches(i).Vertices = v(c{i},:);
        else
            % Draw the voronoi completely
            obj.patches(i) = patch(v(c{i},1), v(c{i},2), 'white', 'Parent', obj.axesHandle);
        end
        
        % Color the patches if possible
        if numel(agents) >= i && agents{i}.currentValue ~= 0
            obj.patches(i).FaceColor = obj.colors{agents{i}.currentValue};
        end
    end
end

end