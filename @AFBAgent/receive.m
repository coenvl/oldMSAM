function receive(obj, msg)
%RECEIVE Summary of this function goes here
%   Detailed explanation goes here

i = obj.variableNum;

% fprintf('Agent %s received message of type %s\n', obj.name, msg.type);

ResultLogger.addResult(msg.type)

switch msg.type
    case AFBAgent.CPA_MSG
        % First check if the message is relevant
        if compareTimestamp(obj, msg)
            % line 7: store the received PA in local var
            obj.cpa = msg.pa;
            
            if isfield(msg, 'cost')
                obj.pastCost = msg.cost;
            end
            
            % line 8 - 10: compare CPA without local to bound
            tempCPA = msg.pa;
            tempCPA(i) = 0;
            
            if obj.calculateCost(tempCPA) > obj.bound
                % cost is too high, start backtrack
                obj.backtrack();
            else
                % cost is okay, try CPA assignment
                obj.assign_CPA();
            end
        end
%     case AFBAgent.FB_CPA
%         % lines 5-6: Do computation for parent node...
%         cost = obj.calculateCost(msg.pa);
%         msg.sender.send(struct('type', AFBAgent.FB_ESTIMATE, ...
%                                 'cost', cost, ...
%                                 'timestamp', obj.timestamp, ...
%                                 'index', i));
%     case AFBAgent.FB_ESTIMATE
%         % lines 14-16: store estimate
%         if compareTimestamp(obj, msg)
%             obj.futureCost(msg.index) = msg.cost;
%             if sum([obj.pastCost obj.localCost obj.futureCost]) >= obj.bound
%                 assign_CPA(); %line 16: Continue search
%             end
%         end
    case AFBAgent.TERMINATE
        % This means we are done
        obj.setValue(obj.boundPA(i));
    case AFBAgent.NEW_SOLUTION
        % A new solution has been found, lower the upperbound
        obj.bound = msg.pa_cost;
        obj.boundPA = msg.pa;
    otherwise
        error('Unknown message type %s', msg.type);
end

end

function new = compareTimestamp(obj, msg)
% Returns true if the message is newer than specified in the object

% Compare only the relevant part...
n = min(numel(msg.timestamp), numel(obj.timestamp));
new = any(msg.timestamp(1:n) >= obj.timestamp(1:n));

% Update the timestamp if the message was newer AND we reset the local
% thing?
if new; 
    obj.timestamp = [msg.timestamp(1:obj.variableNum - 1) 1]; 
else
    keyboard % Would this happen even in serial computation?
end

end
