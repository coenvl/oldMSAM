function solution = solve(obj, problemFile, solverType, timeout)
%SOLVE Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    problemFile = fullfile(pwd, 'temp.xml');
end

if nargin < 3
    %solverType = 'asodpop.ASODPOPsolver';
    %solverType = 'dpop.DPOPsolver';
    %solverType = 'adopt.ADOPTsolver'; % SOOO slow
    %solverType = 'synchbb.SynchBBsolver';
    solverType = 'afb.AFBsolver';
end

if nargin < 4
    timeout = [];
end

obj.export(problemFile);
solution = solveDCOP(problemFile, solverType, [], timeout);
assignments = solution.getAssignments();

%Apply the solution
for a = 1:numel(obj.nodeNames)
    X = obj.nodeNames{a};
    value = assignments.get(X).intValue;
    obj.variables(X).setValue(uint32(value));
end

obj.show();