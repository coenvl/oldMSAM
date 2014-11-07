function h = show(obj)
if isempty(obj.figureHandle) || ~ishandle(obj.figureHandle)
    obj.createFigure();
end

centers = obj.nodeData();

% Add some external bounding points
val = (max(centers(:)) + 1) * 2;
p_ext = [centers; val val; val -val; -val -val; -val val];

% Create the actual patches in the voronoi diagram (i.e. not
% just the edges.
[v,c] = voronoin([p_ext(:,1) p_ext(:,2)]);

% agents = obj.agents.values;
variables = obj.variables.values;

% Draw the patches in the voronoi
for i = 1:numel(c)
    if ~any(isinf(v(c{i},:))) % This still seems weird, aren't I sure that the invalid patches come last?
        if numel(obj.patches) >= i && ishandle(obj.patches(i))
            % Update the patch
            set(obj.patches(i), 'Faces', 1:numel(c{i}));
            set(obj.patches(i), 'Vertices', v(c{i},:));
        else
            % Draw the voronoi completely
            obj.patches(i) = patch(v(c{i},1), v(c{i},2), 'white', 'Parent', obj.axesHandle);
            obj.text(i) = text(centers(i,1), centers(i,2), sprintf('%d', i), 'HorizontalAlignment', 'center');
        end
        
        % Color the patches if possible
        if numel(variables) >= i && variables{i}.isSet()
            value = double(variables{i}.getValue());
            set(obj.patches(i), 'FaceColor', obj.colors{value});
        end
    end
end

h = obj.figureHandle;

end