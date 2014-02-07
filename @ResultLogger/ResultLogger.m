classdef ResultLogger < handle
    %RESULTLOGGER Class to keep track of the optimization loop results
    
    properties (Access = private)
        resultMap
        resultIdx
        fieldnames
    end
    
    methods (Access = private)
        function obj = ResultLogger()
            %% ResultLogger
            % Create a result logger in order to keep the results accross
            % multiple calls of the design loop.
            
            obj.init();
        end
    end
    
    methods (Static)
        function obj = getInstance()
            %% getInstance
            % Get the singleton instance of the ResultLogger
            
            persistent resultLoggerInstance;
            
            if isempty(resultLoggerInstance) || ~isvalid(resultLoggerInstance)
                resultLoggerInstance = ResultLogger;
            end
            
            obj = resultLoggerInstance;
        end

        function names = varNames(names)
            %% varNames
            % Using this function you can set the names to use when logging
            
            obj = ResultLogger.getInstance();
            
            if nargin > 0
                if ~iscell(names)
                    error('ResultLogger:varNames:InputNoCell', ...
                        'Input must be a cell of variable names');
                end
                
                obj.fieldnames = cell(size(names));
                for i = 1:numel(names)
                    if ~ischar(names{i})
                        error('ResultLogger:varNames:InputNoCellOfStrings', ...
                            'Input must be a cell of character arrays');
                    end
                    
                    obj.fieldnames{i} = genvarname(names{i});
                end
            end
            
            % Return the fieldnames
            names = obj.fieldnames;
        end
        
        function addResult(varargin)
            %% addResult
            % Add a resulting alpha value to a set of parameters. Possibly
            % add some other variables that need to be logged.
            obj = ResultLogger.getInstance();
            
            for i = numel(varargin)
                % Get the field name
                if i > numel(obj.fieldnames)
                    fieldname = sprintf('var%d', i);
                else
                    fieldname = obj.fieldnames{i};
                end
                obj.resultMap(obj.resultIdx).(fieldname) = varargin{i};
            end
            
            obj.resultIdx = obj.resultIdx + 1;
        end
        
        function reset()
            %% reset
            % Set all the properties of the object as fresh
            obj = ResultLogger.getInstance();
            
            obj.init();
        end
        
        function results = getResults()
            %% getResults
            % Get the stored results of the object
            obj = ResultLogger.getInstance();
            results = obj.resultMap;
        end
    end
    
    methods (Access = private)
        function init(obj)
            %% init
            % Makes a new resultlogger
            obj.resultMap = struct();
            obj.resultIdx = 1;
        end
    end
    
end

