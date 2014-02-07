function solution = testRRDCOP

% Default settings
d = fileparts(mfilename('fullpath'));
problemFile = fullfile(d,'senseCompress.xml');
solverType = 'synchbb.SynchBBsolver';
agentFile = '/frodo2/algorithms/synchbb/SynchBBagentJaCoP.xml';
%solverType = 'afb.AFBsolver';
%agentFile = '/frodo2/algorithms/afb/AFBagentJaCoP.xml';
timeout = 10e3; %Time in milliseconds
xsdScheme = fullfile(getenv('path_frodo'), 'src\frodo2\algorithms\XCSPschemaJaCoP.xsd');

[valid, msg] = validateProblemFile(problemFile, xsdScheme);

if ~valid
    e = MException('RRDCOP:InvalidProblemFile',...
	'Invalid problem file %s\n\n', problemFile, msg);
    e.throw();
else
    solution = solveDCOP(problemFile, solverType, agentFile, timeout);
end

%% Print the solution
a = solution.getAssignments();

if (a.get('mapping1').doubleValue)
    mapping = 1;
    effort = a.get('compression1').doubleValue;
    algorithm = a.get('algorithm1').doubleValue;    
else
    mapping = 2;
    effort = a.get('compression2').doubleValue;
    algorithm = a.get('algorithm2').doubleValue;   
end

algorithmNames = {'rar', 'zip'};
fprintf('Compression algorithm is assigned to node %d\n', mapping)
fprintf('Algorithm is %s with effort %d\n', algorithmNames{algorithm}, effort);
fprintf('Total utility is %d\n', solution.getUtility.doubleValue);
