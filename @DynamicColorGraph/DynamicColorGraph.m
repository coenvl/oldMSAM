classdef DynamicColorGraph < handle
    
    properties (Constant)
        colors@cell matrix = {[1 0 0] [0 1 0] [0 0 1]}; % [1 1 0] [0 1 1]};
    end
    
    properties(GetAccess = public, SetAccess = private)
        sampleType = 'randomSample';
%         sampleType = 'poissonSample';
%         sampleType = 'honeyCombSample';
%         sampleType = 'circleSample';
    end
    
    properties (Access = public)
        % Handles to the graphics to quickly draw stuff
        figureHandle;
        axesHandle;
        patches;
        text;
        
        % The data
        maxsize@double scalar;
        nodeData@double matrix;
        varNames@cell;
        variables@containers.Map scalar;
        
        % The agents
        agents@containers.Map scalar;
        agentNames@cell;
    end
    
    methods (Access = public)
        function obj = DynamicColorGraph(n, maxsize)
            if nargin < 2
                maxsize = 10;
            end
            
            % Initialize variables
            obj.maxsize = maxsize;
            obj.nodeData = feval(obj.sampleType, maxsize, n);
            
%             [a,b] = meshgrid(linspace(0,maxsize,sqrt(n)),linspace(0,maxsize,sqrt(n)));
%             obj.nodeData = [a(:) b(:)];

            realN = size(obj.nodeData, 1);
            
            obj.varNames = cell(1,realN);
            obj.variables = containers.Map('KeyType','char','ValueType','any');
            obj.agents = containers.Map('KeyType','char','ValueType','any');
            obj.agentNames = cell(1,realN);
            
            for i = 1:realN
                varName = sprintf('node%03d', i);
                obj.agentNames{i} = sprintf('agent%03d', i);
                obj.varNames{i} = varName; 
                
                obj.variables(varName) = nl.coenvl.sam.variables.IntegerVariable(1, ...
                    numel(DynamicColorGraph.colors), ...
                    varName);
            end
            
            nl.coenvl.sam.ExperimentControl.ResetExperiment();
        end
        
        function varName = variableName(obj, i)
            varName = obj.nodeNames{i};
        end
                
        %% Functions defined in other files
        addAgents(obj, agentType);
        
        c = neqConstraints(obj);
        
        % export the problem as a FRODO xml file
        export(obj, filename, options);
        
        % Visualize it using a voronoi diagram
        h = show(obj);
        
        % Move the node centers slightly..
        randomWalk(obj, stddev);
        
        % Solve using FRODO
        solution = solve(obj, problemfile, solverType, timeout);
        
        % Solve using SAM
        startDCOP(obj);
        
        % Specially for CFL
        tickCFL(obj);
        
        % Get the current coloring
        [a,c] = getAssignments(obj);
        
        % Get the cost - the amount of matching coloroed neighbors
        cost = getCost(obj);
    end
    
    methods (Access = private)
        function createFigure(obj)
            % Assuming hgVersion 2
            obj.figureHandle = clf;
            obj.axesHandle = gca;
            
            % Set axis limits to fit the original data
            set(obj.axesHandle, 'XLim', [0 obj.maxsize]);
            set(obj.axesHandle, 'YLim', [0 obj.maxsize]);
            axis(obj.axesHandle, 'square')
            
            % Remove the ticks
            set(obj.axesHandle, 'XTick', []);
            set(obj.axesHandle, 'YTick', []);
            
            set(obj.axesHandle, 'Position', [0.025 0.025 .95 .95]);
        end
    end    
end