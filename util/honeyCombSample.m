function data = honeyCombSample(size, n)
%CIRCLESAMPLE Summary of this function goes here
%   Detailed explanation goes here

% The data should be in the format as if data = size .* rand(n, 2);

numCols = ceil(sqrt(n));
numRows = ceil(n / numCols);

rowHeight = size / (numRows + 1);
rowY = cumsum(repmat(rowHeight,1,numRows));

colWidth = size / (numCols + 1);
colX = cumsum(repmat(colWidth,1,numCols));

data = [];
for i = numRows:-1:1
    if mod(i,2) == 1
        offset = .25 * colWidth;
    else
        offset = -.25 * colWidth;
    end
    data = [data; [colX' + offset repmat(rowY(i), numCols, 1)]];
end

data = data(1:n, :);

end

