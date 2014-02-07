function obj = randomWalk(obj, stddev)
%% randomWalk@DynamicColorGraph(obj, stddev)
% Move the nodes' centers according to a normal distribution with given
% standard deviation. (Default stddev value is 1)

if nargin < 2; stddev = 1; end
obj.nodeData = obj.nodeData + randn(size(obj.nodeData)) * stddev;

% Make sure the centers don't walk outside the window
obj.nodeData = abs(obj.nodeData); % "Bounce" after 0
k = obj.nodeData > obj.maxsize;
obj.nodeData(k) = obj.maxsize + (obj.maxsize - obj.nodeData(k)); % "Bounce" after maxsize

end