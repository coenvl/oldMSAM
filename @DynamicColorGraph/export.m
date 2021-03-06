function [ neqConstraints ] = export(obj, filename, options)
%PROBLEMDEF Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    [filename, dir] = uiputfile('*.xml', 'Export as problem file');
    filename = fullfile(dir,filename);
end

if nargin < 3 || isempty(options); options = struct; end

if ~isfield(options, 'name') || isempty(options.name);
    options.name = 'testProblem';
end

neqConstraints = obj.neqConstraints();

nAgents = numel(obj.agentNames);

% From here is just printing the problem .xml file
fid = fopen(filename, 'w+');

xsdScheme = fullfile(getenv('path_frodo'), 'src\frodo2\algorithms\XCSPschema.xsd');

% Print the header
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid, '<instance xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="%s">\n', xsdScheme);

% Print info about the problem
fprintf(fid, '  <presentation name="%s" maxConstraintArity="2" maximize="false" format="XCSP 2.1_FRODO">\n', options.name);
fprintf(fid, '    <stats name="number of nodes">%d</stats>\n', nAgents);
fprintf(fid, '    <stats name="number of colors">%d</stats>\n', numel(obj.colors));
fprintf(fid, '    <stats name="number of uncontrollable nodes">0</stats>\n');
fprintf(fid, '  </presentation>\n');
          
% Define the agents
fprintf(fid, '  <agents nbAgents="%d">\n', nAgents);
for i = 1:nAgents
    fprintf(fid, '    <agent name="%s" />\n', obj.agentNames{i});
end
fprintf(fid, '  </agents>\n');

% Export the domain
fprintf(fid, '  <domains nbDomains="1">\n');
fprintf(fid, '    <domain name="colors" nbValues="%d">1..%d</domain>\n', numel(obj.colors), numel(obj.colors));
fprintf(fid, '  </domains>\n');

% Assign the variables
fprintf(fid, '  <variables nbVariables="%d">\n', nAgents);
for i = 1:nAgents
    fprintf(fid, '    <variable name="%s" domain="colors" agent="%s"/>\n', obj.varNames{i}, obj.agentNames{i});
end
fprintf(fid, '  </variables>\n');

% Define relations
fprintf(fid, '  <relations nbRelations="1">\n');
fprintf(fid, '    <relation name="NEQ" arity="2" nbTuples="%d" semantics="soft" defaultCost="0">\n', numel(obj.colors));
ineqstr = sprintf('%d %d|', reshape(repmat(1:numel(obj.colors),2,1), 1, []));
fprintf(fid, '      1: %s\n', ineqstr(1:end-1));
fprintf(fid, '    </relation>\n');
fprintf(fid, '  </relations>\n');

% Set the constraints
fprintf(fid, '  <constraints nbConstraints="%d">\n', size(neqConstraints, 1));
for i = 1:size(neqConstraints, 1)
    X = obj.varNames{neqConstraints(i, 1)};
    Y = obj.varNames{neqConstraints(i, 2)};
    fprintf(fid, '    <constraint name="%s_AND_%s_have_different_colors" arity="2" scope="%s %s" reference="NEQ"/>\n', X, Y, X, Y);
end
fprintf(fid, '  </constraints>\n');

% And add the footer
fprintf(fid, '</instance>\n');

fclose(fid);

%% Check if succesfull
validateProblemFile(filename, xsdScheme);

end

