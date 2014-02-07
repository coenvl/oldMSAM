classdef AFBAgent < Agent
    %AFBAGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected, Constant)
        % Message types used by the AFB agent
        CPA_MSG = 1; %'AFB Current Partial Assignment Message';
        FB_ESTIMATE = 2; %'AFB Forward Bound Estimate';
        FB_CPA = 3; %'AFB Forward Bound Current Partial Assignment';
        NEW_SOLUTION = 4; %'AFB New Solution';
        TERMINATE = 5; %'AFB Terminate';
    end
    
    properties (Access = private)
        % The current partial assignment
        cpa@uint8 matrix;

        % The current timestamp
        timestamp@uint64;
        
        % Past cost is the cost of "upper" assignments
        pastCost@double scalar;
        
        % Local-cost (or current) is the cost of OUR assignment
        localCost@double scalar;
        
        % Estimated future cost via the FB_ESTIMATE messages    
        futureCost@double matrix;
        
        bound@double scalar;
        
        boundPA@uint8 matrix;
    end
    
    methods
        function obj = AFBAgent(varargin)
            obj = obj@Agent(varargin{:});
            obj.timestamp(obj.variableNum) = uint64(1);
            obj.bound = Inf;
        end
        
        function reset(obj)
            obj.children = {};
            obj.timestamp(obj.variableNum) = uint64(1);
            obj.cpa = uint8([]);
            obj.pastCost = 0;
            obj.localCost = 0;
            obj.futureCost = [];
            obj.bound = Inf;
            obj.boundPA = uint8([]);
        end
        
        % Initialization
        init(obj);
        
        % Receiving messages
        receive(obj,msg);
    end
    
    methods (Access = protected)
        generate_CPA(obj);
        assign_CPA(obj);
        backtrack(obj);
        cost = calculateCost(obj, pa);
    end
    
end

