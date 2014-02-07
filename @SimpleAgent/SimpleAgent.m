classdef SimpleAgent < Agent
    %SIMPLEAGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = SimpleAgent(varargin)
            obj = obj@Agent(varargin{:});
        end
        
        function init(~)
            error('SimpleAgents do not offer this functionality')
        end
        
        function receive(obj, ~)
            fprintf('SimpleAgent %s received a message\n', obj.name);
        end
    end
    
end

