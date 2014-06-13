function addAgents(obj, agentType)
%ADDAGENTS Summary of this function goes here
%   Detailed explanation goes here

% For example agentType can have such values
% agentType = 'nl.coenvl.sam.agents.AFBAgent';
% agentType = 'nl.coenvl.sam.agents.GreedyAgent';
% agentType = 'nl.coenvl.sam.agents.CooperativeAgent';
% agentType = 'nl.coenvl.sam.agents.LocalGreedyAgent';

nl.coenvl.sam.ExperimentControl.ResetExperiment();

n = numel(obj.agentNames);

% create Agents that are assigned to the nodes
for i = 1:n
    % Create names
    agentName = sprintf('agent%03d', i);
    obj.agentNames{i} = agentName;
    obj.nodeNames{i} = sprintf('node%03d', i);

    % Create Java Objects
    var = nl.coenvl.sam.variables.IntegerVariable(1, ...
        numel(DynamicColorGraph.colors), ...
        obj.nodeNames{i});
    agent = feval(agentType, agentName, var);

    % Store data
    obj.variables(obj.nodeNames{i}) = var;
    obj.agents(agentName) = agent;
end


end

