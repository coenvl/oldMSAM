function startup

%% First the matlab path for local environment
rootpath = fileparts(mfilename('fullpath'));

addpath(rootpath);
addpath(fullfile(rootpath, 'util'));

%% Search for the Frodo2 framework, and add it

% Add the class files from the FRODOpath
switch getenv('computername')
    case 'PC-13613'
        FRODOpath = 'C:\Develop\java\frodo2';
        JSAMpath = 'C:\Develop\git\jSAM';
    otherwise
        error('Please make sure the computer name is added to %s', mfilename)
end

% Add jSAM libraries
if exist(fullfile(JSAMpath, 'bin'), 'dir')
    javaaddpath(fullfile(JSAMpath, 'bin'));
end

setenv('path_frodo', FRODOpath);

% Add FRODO libraries
if exist(fullfile(FRODOpath, 'bin'), 'dir')
    javaaddpath(fullfile(FRODOpath, 'bin'));
end

frodojars = dir(fullfile(FRODOpath, 'lib', '*.jar'));
javaaddpath(fullfile(FRODOpath, 'lib', {frodojars.name}));

end