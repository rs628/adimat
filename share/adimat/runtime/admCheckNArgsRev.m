% function r = admCheckNArgsRev(functionName, resultFunctionName, ...
%                              nFuncArgs, nActArgs, fNargout,
%                              nActResults, nFunctionHandles)
%
% Check whether the amount of function and derivative arguments is OK
% for differentiated function resultFunctionName.
%
% Copyright 2010,2011 Johannes Willkomm, Scientific Computing Group
%                     TU Darmstadt
function r = admCheckNArgsRev(functionName, resultFunctionName, ...
                              nFuncArgs, nActArgs, fNargout, ...
                              nActResults, nFunctionHandles)
  r = true;
  % check if nargout and nargin are as expected
  nin = nargin(functionName);
  if nFuncArgs ~= nin
    r = false;
    error('adimat:admDiffFor:wrongNumberOfInputParameters', ...
          ['The number of input parameters of function %s is %d, but %d arguments were given.\n'], ...
          functionName, nin, nFuncArgs);
  end
  ndin = nargin(resultFunctionName);
  % FIXME: here we would like to use ~= instead of >, but when the
  % .nargout field is used we must be more carefull
  if nActResults + nFuncArgs > ndin
    r = false;
    error('adimat:admDiffFor:wrongNumberOfInputParameters', ...
          ['The number of input parameters of RM derivative function %s\nshould be at least %d, but is %d.\n' ...
           'This happens when an output parameter becomes active accidentally and an adjoint input\nparameter is generated for it.' ...
           ' The solution is usually to specify that\nparameter as dependent, too.'], ...
          resultFunctionName,  nActResults + nFuncArgs, ndin);
  end
  nout = nargout(functionName);
  if nout < fNargout
    error('adimat:admDiffFor:wrongNumberOfOutputParameters', ...
          ['The number of output parameters of function %s is %d, but %d arguments\n' ...
           'were requested in option field nargout.\n'], ...
          functionName, nout, admOpts.nargout);
  end
  ndout = nargout(resultFunctionName);
  if nActArgs + nargout(functionName) - nFunctionHandles ~= ndout
    r = false;
    error('adimat:admDiffFor:wrongNumberOfOutputParameters', ...
          ['The number of output parameters of RM derivative function %s\nshould be %d, but is %d.\n' ...
           'This happens when an input parameter becomes active accidentally and an adjoint output\nparameter is generated for it.' ...
           ' The solution is usually to specify that\nparameter as independent, too.'], ...
          resultFunctionName,  nActArgs + nargout(functionName), ndout);
  end
% $Id: admCheckNArgsRev.m 3279 2012-05-09 09:26:07Z willkomm $
