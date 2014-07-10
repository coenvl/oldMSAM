clear all; clear classes; clear java; startup
% rng(3)
numSizes = 3;
numExps = 10;
doAFB = true;

if doAFB
    sizeExp = floor(linspace(10,20,numSizes));
else
    sizeExp = floor(linspace(20,500,numSizes));
end

greedyCost = zeros(1,numSizes);
afbCost = zeros(1,numSizes);
coopCost = zeros(1,numSizes);
uniqueFirstCost = zeros(1,numSizes);

greedyMsgs = zeros(1,numSizes);
afbMsgs = zeros(1,numSizes);
coopMsgs = zeros(1,numSizes);
uniqueFirstMsgs = zeros(1,numSizes);

for s = 1:numSizes
    for i = 1:numExps
        dcg = DynamicColorGraph(sizeExp(s));
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.UniqueFirstCooperativeAgent');
        dcg.startDCOP();
        pause(1);
        dcg.show();
        uniqueFirstCost(s) = uniqueFirstCost(s) + dcg.getCost();
        uniqueFirstMsgs(s) = uniqueFirstMsgs(s) + getNumberOfHashMessages();
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.CooperativeAgent');
        dcg.startDCOP();
        pause(1);
        dcg.show();
        coopCost(s) = coopCost(s) + dcg.getCost();
        coopMsgs(s) = coopMsgs(s) + getNumberOfHashMessages();
        
        nl.coenvl.sam.ExperimentControl.ResetExperiment();
        dcg.addAgents('nl.coenvl.sam.agents.LocalGreedyAgent');
        dcg.startDCOP();
        pause(1);
        dcg.show();
        greedyCost(s) = greedyCost(s) + dcg.getCost();
        greedyMsgs(s) = greedyMsgs(s) + getNumberOfHashMessages();
        
        if doAFB
            nl.coenvl.sam.ExperimentControl.ResetExperiment();
            dcg.addAgents('nl.coenvl.sam.agents.AFBAgent');
            dcg.startDCOP();
            pause(3 + sizeExp(s)/4);
            dcg.show();
            afbCost(s) = afbCost(s) + dcg.getCost();
            afbMsgs(s) = afbMsgs(s) + getNumberOfHashMessages();
        end
    end
end

%%
figure(187)
clf
subplot(2,1,1)
if doAFB
    plot(sizeExp, [afbCost ./ numExps ; uniqueFirstCost ./ numExps ; coopCost ./ numExps; greedyCost ./ numExps]);
    legend('AFB', 'UniqueFirst', 'Cooperative', 'Greedy', 'Location', 'NorthWest');
else
    plot(sizeExp, [uniqueFirstCost ./ numExps ; coopCost ./ numExps; greedyCost ./ numExps]);
    legend('UniqueFirst', 'Cooperative', 'Greedy', 'Location', 'NorthWest');
end

title('Solution cost');
xlabel('Problem size');
ylabel('Cost')

subplot(2,1,2);
if doAFB
    semilogy(sizeExp, [afbMsgs ./ numExps; uniqueFirstMsgs ./ numExps ; coopMsgs ./ numExps; greedyMsgs ./ numExps]);
    legend('AFB', 'UniqueFirst', 'Cooperative', 'Greedy', 'Location', 'NorthWest');
else
    plot(sizeExp, [uniqueFirstMsgs ./ numExps ; coopMsgs ./ numExps; greedyMsgs ./ numExps]);
    legend('UniqueFirst', 'Cooperative', 'Greedy', 'Location', 'NorthWest');
end
title('Solution speed');
xlabel('Problem size');
ylabel('#Messages');

