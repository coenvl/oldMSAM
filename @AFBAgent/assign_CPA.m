function assign_CPA(obj)
%ASSIGN_CPA Summary of this function goes here
%   Detailed explanation goes here

%obj.cpa = cpa;
i = obj.variableNum;

% line 19: Clear estimates
obj.futureCost = zeros(1,i);

if (numel(obj.cpa) < i || obj.cpa(i) == 0)
    % Try every value in domain
    lo = 1;
else
    % Continue from the one we had...
    lo = obj.cpa(i) + 1;
end

% line 20: Remove current assigned value
obj.cpa(i) = 0;

for v = lo:max(obj.domain)
   pa = obj.cpa;
   pa(i) = v;
   localCost = obj.calculateCost(pa);
   paCost = obj.pastCost + localCost;
   if paCost < obj.bound
        break;
   end
   v = 0; %#ok<FXSET>
end

if (isempty(v) || v == 0)
    % line 23: No suitable value to try is found, start backtrack
    obj.backtrack();
else
    % line 25: Do the actual assignment
    obj.cpa(i) = v;

    obj.localCost = localCost;
    if isempty(obj.children)
        fprintf('A new solution was found with cost %g\n', paCost);
        
        % A new full assignment was reached, broadcast CPA
        obj.problem.broadCast(struct('type', AFBAgent.NEW_SOLUTION, ...
                                        'pa', pa, ...
                                        'pa_cost', paCost));
        %obj.bound = paCost; % Already done because we do a true broadcast
        obj.assign_CPA;
    else
        % increment counter
        obj.timestamp(i) = obj.timestamp(i) + 1;
        % line 30: Send cpa to next agent
        obj.children{1}.receive(struct('type', AFBAgent.CPA_MSG, ...
                                        'pa', pa, ...
                                        'cost', paCost, ...
                                        'timestamp', obj.timestamp));
        
        % maybe...
        % line 32-33: "Concurrently" send FB_CPA to all lower prio agents
%         for j = 1:numel(obj.children)
%             obj.children{j}.receive(struct('type', AFBAgent.FB_CPA, ...
%                                             'pa', pa, ...
%                                             'timestamp', obj.timestamp, ...
%                                             'sender', obj));
%         end
    end    
end


end

