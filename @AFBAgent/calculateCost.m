function costs = calculateCost(obj, pa)
% What is the cost of a given PA

% Remove the persistent stuff for dynamic graphs!!
if isempty(obj.constraints)
    obj.constraints = obj.problem.neqConstraints();
    %k = any(obj.constraints == obj.variableNum, 2);
    k = obj.constraints(:,2) == obj.variableNum; % otherwise we count double. Should matter for the solution though
    obj.constraints = obj.constraints(k, :);
end

% Cost = sum of all constrained variables that are equal, but not 0
costs = sum(pa(obj.constraints(:,1)) == pa(obj.constraints(:,2)) & ...
            pa(obj.constraints(:,1)) ~= 0);

end