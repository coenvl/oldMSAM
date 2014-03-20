classdef DynamicColorGraph < handle
    
    properties (Constant)
        colors@cell matrix = {[1 0 0] [0 1 0] [0 0 1]};
    end
    
    properties (Access = private)
        % Handles to the graphics to quickly draw stuff
        figureHandle@matlab.ui.Figure scalar;
        axesHandle@matlab.graphics.axis.Axes scalar;
        patches@matlab.graphics.primitive.Patch;
        
        % The data
        maxsize@double scalar;
        nodeData@double matrix;
        nodeNames@cell;
        variables@containers.Map scalar;
        
        % The agents
        agentType@char matrix = 'nl.coenvl.sam.impl.SFBAgent';
        agents@containers.Map scalar;
        agentNames@cell;
    end
    
    methods (Access = public)
        function obj = DynamicColorGraph(n, maxsize, agentType)
            if nargin < 2
                maxsize = 10;
            end
            
            if nargin > 2
                obj.agentType = agentType;
            end
            
            % Initialize variables
            obj.maxsize = maxsize;
            obj.nodeData = maxsize .* rand(n, 2);
            obj.nodeNames = cell(1,n);
            obj.variables = containers.Map('KeyType','char','ValueType','any');
            obj.agents = containers.Map('KeyType','char','ValueType','any');
            obj.agentNames = cell(1,n);
            
            % create Agents that are assigned to the nodes
            for i = 1:n
                % Create names
                agentName = sprintf('agent%03d', i);
                obj.agentNames{i} = agentName;
                obj.nodeNames{i} = sprintf('node%03d', i);
                
                % Create Java Objects
                agent = feval(obj.agentType, agentName);
                var = nl.coenvl.sam.IntegerVariable(java.lang.Integer(1), ...
                    java.lang.Integer(numel(DynamicColorGraph.colors)), ...
                    obj.nodeNames{i});
                agent.assignVariable(var);
                
                % Store data
                obj.variables(obj.nodeNames{i}) = var;
                obj.agents(agentName) = agent;
            end
        end
        
        function varName = variableName(obj, i)
            varName = obj.nodeNames{i};
        end
        
%         function numVars = numVars(obj)
%             numVars = numel(obj.agentNames);
%         end
        
        %% Functions defined in other files
        c = neqConstraints(obj);
        
        % export the problem as a FRODO xml file
        export(obj, filename, options);
        
        % Visualize it using a voronoi diagram
        show(obj);
        
        % Move the node centers slightly..
        randomWalk(obj, stddev);
        
        % Solve using FRODO
        solution = solve(obj, problemfile, solverType, timeout);
        
        % Solve using SAM
        startDCOP(obj);
        
        % Get the current coloring
        [a,c] = getAssignments(obj);
    end
    
    methods (Access = private)
        function createFigure(obj)
            % Assuming hgVersion 2
            obj.figureHandle = clf;
            obj.axesHandle = gca;
            
            % Set axis limits to fit the original data
            obj.axesHandle.XLim = [0 obj.maxsize];
            obj.axesHandle.YLim = [0 obj.maxsize];
        end
    end    
end