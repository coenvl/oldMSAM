function c = neqConstraints(obj)
% Returns a list of indices which may not be equal

centers = obj.nodeData();

% The actual calculation of the inequality constraints
DT = delaunayTriangulation(centers(:,1),centers(:,2));
c = DT.edges;

end