function startDCOP( obj )
%STARTDCOP Summary of this function goes here
%   Detailed explanation goes here

% Agents have a certain ordering
nAgents = numel(obj.agentNames);

% Reset all agents;
for i = 1:nAgents
    agent = obj.agents(obj.agentNames{i});
    var = obj.variables(obj.nodeNames{i});
    var.clear();
    agent.reset();
end

if isa(agent, 'nl.coenvl.sam.agents.OrderedAgent')
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
        if isa(agent, 'nl.coenvl.sam.agents.InequalityConstraintSolvingAgent')
            t = obj.agents(obj.agentNames{v}).getSequenceID();
            agent.addConstraint(t);
        elseif isa(agent, 'nl.coenvl.sam.agents.LocalCommunicatingAgent')
            n = obj.agents(obj.agentNames{v});
            agent.addToNeighborhood(n);
            n.addToNeighborhood(agent);
        end
    end
end

%% Init all agents
for i = numel(obj.agentNames):-1:1
    agent = obj.agents(obj.agentNames{i});
    agent.init();
end

agent = obj.agents(obj.agentNames{1});
if isa(agent, 'nl.coenvl.sam.agents.CooperativeAgent')
    msg = nl.coenvl.sam.messages.HashMessage('GreedyCooperativeSolver:PickAVar');
    agent.push(msg);
elseif isa(agent, 'nl.coenvl.sam.agents.UniqueFirstCooperativeAgent')
    msg = nl.coenvl.sam.messages.HashMessage('UniqueFirstCooperativeSolver:PickAVar');
    agent.push(msg);
elseif isa(agent, 'nl.coenvl.sam.agents.LocalGreedyAgent')
    msg = nl.coenvl.sam.messages.HashMessage('GreedyLocalSolver:AssignVariable');
    agent.push(msg);
end

obj.show;

end

