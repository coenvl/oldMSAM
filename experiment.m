clear all; clear classes; clear java; startup
rng(3)
numExp = 1;

% frodo = zeros(1,numExp);
sam = zeros(1,numExp);

for i = 1:numExp
    nl.coenvl.sam.ExperimentControl.ResetExperiment();
    
    dcg = DynamicColorGraph(10);
    
%     fsol = dcg.solve();
%     fmsgcnt = fsol.getMsgNbrs();
%     frodo(i) = fmsgcnt.get('CPA_MSG');
    
    dcg.startDCOP();
    cost = dcg.getCost()
    pause(1);
    
    smsgcnt = nl.coenvl.sam.messages.HashMessage.getCount();
%     sam(i) = smsgcnt.get(nl.coenvl.sam.solvers.FBSolver.CPA_MSG);
end

% bar([frodo; sam]')