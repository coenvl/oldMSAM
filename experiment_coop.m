clear all; clear classes; clear java; startup
% rng(3)
numSizes = 5;
numExps = 10;
sizeExp = floor(linspace(10,20,numSizes));

greedy = zeros(1,numSizes);
afb = zeros(1,numSizes);
coop = zeros(1,numSizes);

for s = 1:numSizes
    for i = 1:numExps
        dcg = DynamicColorGraph(sizeExp(s));
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.CooperativeAgent');
        dcg.startDCOP();
        pause(1);
        dcg.show();
        coop(s) = coop(s) + dcg.getCost();
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.LocalGreedyAgent');
        dcg.startDCOP();
        pause(1);
        dcg.show();
        greedy(s) = greedy(s) + dcg.getCost();
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.AFBAgent');
        dcg.startDCOP();
        pause(3);
        dcg.show();
        afb(s) = afb(s) + dcg.getCost();
    end
end

figure
hold on
plot(sizeExp, afb ./ numExps, 'g-');
plot(sizeExp, coop ./ numExps, 'b-');
plot(sizeExp, greedy ./ numExps, 'k-');
legend('AFB', 'Cooperative', 'Greedy')