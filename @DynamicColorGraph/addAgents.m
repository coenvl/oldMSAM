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
    agentName = obj.agentNames{i};

    % Create Java Objects
    var = obj.variables(obj.varNames{i});
    var.clear();
    agent = feval(agentType, agentName, var);

    % Store data
    obj.variables(obj.varNames{i}) = var;
    obj.agents(agentName) = agent;
end

end

