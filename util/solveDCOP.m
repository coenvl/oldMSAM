function solution = solveDCOP(problemFile, solverType, agentFile, timeout)
%SOLVE Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    problemFile = fullfile(pwd, 'temp.xml');
end

if nargin < 3
   solverType = 'synchbb.SynchBBsolver';
   %solverType = 'afb.AFBsolver';
end

if nargin < 4 || isempty(agentFile)
    agentFile = [];
elseif ~exist(agentFile, 'file')
    error('SolveDCOP:InexistentAgentFile', 'File %s does not exist', agentFile)
else
    agentFile = ['''' agentFile ''''];
end

if nargin < 5
    timeout = [];
end

if ~exist(problemFile, 'file')
    error('SolveDCOP:InexistentProblemFile', 'File %s does not exist', problemFile)
end

problemDesc = frodo2.algorithms.XCSPparser.parse(problemFile, false);

solver = eval(sprintf('frodo2.algorithms.%s(%s)', solverType, agentFile));
solver.getAgentDesc.getRootElement().getAttribute('measureMsgs').setValue('true');

solution = solver.solve(problemDesc, timeout);