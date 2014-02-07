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

% From here is just printing the problem .xml file
fid = fopen(filename, 'w+');

agents = obj.agents.values;

xsdScheme = fullfile(getenv('path_frodo'), 'src\frodo2\algorithms\XCSPschema.xsd');

% Print the header
fprintf(fid, ['<instance xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n' ...
              '          xsi:noNamespaceSchemaLocation="%s">\n' ...
              '  <presentation name="%s" maxConstraintArity="2"\n' ...
              '                maximize="false" format="XCSP 2.1_FRODO" />\n\n'], xsdScheme, options.name);

% Define the agents
fprintf(fid, '  <agents nbAgents="%d">\n', numel(agents));
for i = 1:numel(agents)
    fprintf(fid, '    <agent name="%s" />\n', agents{i}.name);
end
fprintf(fid, '  </agents>\n\n');

% Export the domain
fprintf(fid, '  <domains nbDomains="1">\n');
fprintf(fid, '    <domain name="colors" nbValues="%d">1..%d</domain>\n', numel(obj.colors), numel(obj.colors));
fprintf(fid, '  </domains>\n\n');

% Assign the variables
fprintf(fid, '  <variables nbVariables="%d">\n', numel(agents));
for i = 1:numel(agents)
    fprintf(fid, '    <variable name="%s" domain="colors" agent="%s"/>\n', agents{i}.variableName, agents{i}.name);
end
fprintf(fid, '  </variables>\n\n');

% Define relations
fprintf(fid, '  <relations nbRelations="1">\n');
fprintf(fid, '    <relation name="NEQ" arity="2" nbTuples="%d" semantics="soft" defaultCost="0">\n', numel(obj.colors));
ineqstr = sprintf('%d %d|', reshape(repmat(1:numel(obj.colors),2,1), 1, []));
fprintf(fid, '      1: %s\n', ineqstr(1:end-1));
fprintf(fid, '    </relation>\n');
fprintf(fid, '  </relations>\n\n');

% Set the constraints
fprintf(fid, '  <constraints nbConstraints="%d">\n', size(neqConstraints, 1));
for i = 1:size(neqConstraints, 1)
    X = agents{neqConstraints(i, 1)}.variableName;
    Y = agents{neqConstraints(i, 2)}.variableName;
    fprintf(fid, '    <constraint name="%s_AND_%s_have_different_colors" arity="2" scope="%s %s" reference="NEQ"/>\n', X, Y, X, Y);
end
fprintf(fid, '  </constraints>\n');

% And add the footer
fprintf(fid, '</instance>\n');

fclose(fid);

%% Check if succesfull
validateProblemFile(filename, xsdScheme);

end

