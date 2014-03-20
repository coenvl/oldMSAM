function startDCOP( obj )
%STARTDCOP Summary of this function goes here
%   Detailed explanation goes here

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
    parent.addChild(obj.agents(obj.agentNames{i+1}));
    %for j = (i+1):numel(obj.agentNames)
    %    parent.addChild(obj.agents(obj.agentNames{j}));
    %end
end

for i = 2:nAgents
    child = obj.agents(obj.agentNames{i});
    child.setParent(obj.agents(obj.agentNames{i-1}));
end

%% Add al the constraints
c = obj.neqConstraints();

for i = 1:nAgents
    k = find(c(:,2) == i);
    if isempty(k)
        continue;
    end
    
    agent = obj.agents(obj.agentNames{i});
    for v = c(k,1)'
        t = obj.agents(obj.agentNames{v}).getSequenceID();
        agent.addConstraint(t);
    end
end

%% Init all agents
for i = numel(obj.agentNames):-1:1
    agent = obj.agents(obj.agentNames{i});
    agent.init();
end

obj.show;

end

