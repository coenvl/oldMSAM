function [valid, msg] = validateProblemFile(problemFile, xsdScheme)

localpath = fileparts(mfilename('fullpath'));
jarFile = fullfile(localpath, 'XMLSchema11Test.jar');

cmd = sprintf('java -jar %s %s %s', jarFile, problemFile, xsdScheme);

[ret, msg] = system(cmd);

valid = ret == 0;

end
