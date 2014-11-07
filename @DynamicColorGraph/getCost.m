function cost = getCost(obj)

cost = 0;
c = neqConstraints(obj);

for i = 1:size(c,1)
    
    varA = obj.variables(obj.varNames{c(i,1)});
    varB = obj.variables(obj.varNames{c(i,2)});
    if varA.getValue() == varB.getValue()
        cost = cost + 1;
    end
    
end