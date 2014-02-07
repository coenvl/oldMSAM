function init(obj)
obj.bound = Inf;  % line 1: Initialize with infinite upperbound

if (obj.variableNum == 1)
    obj.generate_CPA(); % line 3: First node will always start generating CPA
    obj.assign_CPA(); % line 4: And after that it will assign the CPA
end

end