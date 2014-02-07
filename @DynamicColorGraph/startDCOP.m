function startDCOP( obj )
%STARTDCOP Summary of this function goes here
%   Detailed explanation goes here

% Since the thing is not really parallel, we need some real recursion
set(0,'RecursionLimit',5000)

% Agents have a certain ordering
nAgents = numel(obj.agentNames);

% Reset all agents;
for agent = obj.agents.values
    agent{1}.reset();
end

% We assume a static final ordering where each agent has just one child
% Therefore the algorithm is never really asynchronous
for i = 1:(nAgents-1)
    parent = obj.agents(obj.agentNames{i});
    for j = (i+1):numel(obj.agentNames)
        parent.addChild(obj.agents(obj.agentNames{j}));
    end
end

for i = 2:nAgents
    child = obj.agents(obj.agentNames{i});
    child.setParent(obj.agents(obj.agentNames{i-1}));
end

agent = obj.agents(obj.agentNames{1});
agent.init();

obj.show;

end

