function data = circleSample(size, n)
%CIRCLESAMPLE Summary of this function goes here
%   Detailed explanation goes here

% The data should be in the format as if data = size .* rand(n, 2);

center = [.5 .5] * size;
radius = .35 * size;

angles = linspace(0,2*pi, n);

dx = radius .* sin(angles);
dy = radius .* cos(angles);

x = center(1) + dx;
y = center(2) + dy;

data = [center; x' y'];
data(end,:) = [];

end

