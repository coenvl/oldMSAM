classdef DynamicColorGraph < handle
    
    properties (Constant)
        colors@cell matrix = {[1 0 0] [0 1 0] [0 0 1]};
    end
    
    properties (Access = private)
        % Handles to the graphics to quickly draw stuff
        figureHandle@matlab.ui.Figure scalar;
        axesHandle@matlab.graphics.axis.Axes scalar;
        patches@matlab.graphics.primitive.Patch;
        text@matlab.graphics.primitive.Text;
        
        % The data
        maxsize@double scalar;
        nodeData@double matrix;
        nodeNames@cell;
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
            obj.nodeData = maxsize .* rand(n, 2);
            obj.nodeNames = cell(1,n);
            obj.variables = containers.Map('KeyType','char','ValueType','any');
            obj.agents = containers.Map('KeyType','char','ValueType','any');
            obj.agentNames = cell(1,n);
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
        show(obj);
        
        % Move the node centers slightly..
        randomWalk(obj, stddev);
        
        % Solve using FRODO
        solution = solve(obj, problemfile, solverType, timeout);
        
        % Solve using SAM
        startDCOP(obj);
        
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
            obj.axesHandle.XLim = [0 obj.maxsize];
            obj.axesHandle.YLim = [0 obj.maxsize];
        end
    end    
end