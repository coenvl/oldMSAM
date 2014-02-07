function backtrack(obj)

if (obj.variableNum == 1)
    obj.problem.broadCast(struct('type', AFBAgent.TERMINATE));
else
    % This message does not require a cost?
    obj.parent.receive(struct('type', AFBAgent.CPA_MSG, ...
                                'pa', obj.cpa, ...
                                'timestamp', obj.timestamp));

end