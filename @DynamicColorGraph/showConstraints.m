function showConstraints(obj)
%SHOWCONSTRAINTS Summary of this function goes here
%   Detailed explanation goes here

obj.show();

hold on;

x = obj.nodeData(:,1);
y = obj.nodeData(:,2);

tri = delaunay(x,y);

triplot(tri,x,y);
scatter(x,y,350,'ow','filled');
scatter(x,y,350,'ob');
for i = 1:size(x,1)
    h = text(x(i),y(i), sprintf('%d', i), 'HorizontalAlignment', 'center'); %, 'BackgroundColor', [1 1 1], 'EdgeColor', [0 0 1]);
end

end

