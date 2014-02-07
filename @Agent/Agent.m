classdef Agent < handle
    %AGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        problem@DynamicColorGraph scalar;
        children@cell;
        parent@Agent scalar;
        domain@uint8 matrix;
        constraints;
    end
    
    properties (SetAccess = private)
        name@char matrix;
        variableNum@uint8 scalar;
        variableName@char matrix;
        currentValue@uint8 scalar;
    end
    
    methods
        function obj = Agent(name, prob, num)
            % Agent starts off with random assigned color
            obj.currentValue = randi(numel(DynamicColorGraph.colors));
            obj.name = name;

            % Assigns a certain variable from a problem to this agent
            obj.problem = prob;
            obj.variableNum = num;
            obj.variableName = obj.problem.variableName(num);
            obj.domain = uint8(1:numel(DynamicColorGraph.colors));
            
            obj.children = {};
        end
        
        function setValue(obj, value)
            if ~ismember(value, obj.domain)
                error('Agent:SetColor:InvalidValue', ...
                    'Value is not within problem domain');
            end
            obj.currentValue = value;
        end
            
        function setParent(obj, parent)
            obj.parent = parent;
        end
        
        %{
        function setChildren(obj, children)
            if ~iscell(children)
                error('Agent:setChildren:inputNotCell', ...
                'Children must be a cell of zero or more Agents');
            end
            
            for c = children
                if ~isa(c{1}, 'Agent')
                    error('Agent:setChildren:childNotAgent', ...
                        'Children must be a cell of zero or more Agents');
                end
            end
            
            obj.children = children;
        end
        %}
        
        function clearChildren(obj)
            obj.children = {};
        end
        
        function addChild(obj, c)
            if ~isa(c, 'Agent')
                error('Agent:addChild:childNotAgent', ...
                    'Child must be of type Agent');
            end
            
            obj.children = [obj.children {c}];
        end
        
    end
    
    methods (Abstract)
        init(obj);
        receive(obj, message);
        reset(obj);
    end
    
end

