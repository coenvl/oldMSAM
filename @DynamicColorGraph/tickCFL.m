function tickCFL(obj)

agentType = 'nl.coenvl.sam.agents.TickCFLAgent';

if ~isa(obj.agents(obj.agentNames{1}), agentType)
    error('Must use on agents of type %s', agentType);
else
    for i = numel(obj.agentNames):-1:1
        agent = obj.agents(obj.agentNames{i});
        agent.push(nl.coenvl.sam.solvers.TickCFLSolver.TICK);
    end
end

end

