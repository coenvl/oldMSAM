function startup

%% First the matlab path for local environment
addpath util;

%% Search for the Frodo2 framework, and add it

% Add the class files from the FRODOpath
switch getenv('computername')
    case 'PC-13613'
        FRODOpath = 'C:\Develop\java\frodo2';
    otherwise
        error('Please make sure the computer name is added to %s', mfilename)
end

setenv('path_frodo', FRODOpath);

% Add additional required libraries
if exist(fullfile(FRODOpath, 'bin'), 'dir')
    javaaddpath(fullfile(FRODOpath, 'bin'));
end

frodojars = dir(fullfile(FRODOpath, 'lib', '*.jar'));
javaaddpath(fullfile(FRODOpath, 'lib', {frodojars.name}));

end