function data = poissonSample(size, n)
%POISSONSAMPLE Summary of this function goes here
%   Detailed explanation goes here

% as if size .* rand(n, 2);

k = 30; %maximum number of samples before rejection

r = sqrt(size^2/n) * .9; % Some kind of weird estimation for how big the radius should be

% Initialize
data = [rand * size, rand * size];
queue = 1;

while (~isempty(queue))
    % pick random item from queue;
    i = randi(length(queue));
    
    % Create k samples around data[i];
    found = false;
    for j = 1:30
        a = 2 * pi * rand;
        ri = r + rand * r;
        x = data(queue(i),1) + ri * cos(a);
        y = data(queue(i),2) + ri * sin(a);
        
        if (x > 0 && x < size && y > 0 && y < size && min(pdist2([x,y], data)) > r)
            data = [data; x y];
            queue(end + 1) = length(data);
            found = true;
            break;
        end
    end
    
    if ~found
        queue(i) = [];
    end
end

end