function r = isempty(g)
%MEXADDERIV/ISEMPTY Return true if prod(size(g)) = 0.
%
% see also mexadderiv/size
%
% Copyright 2010,2011 Johannes Willkomm, Institute for Scientific Computing   
% Copyright 2001-2008 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!
%
  r = prod(size(g)) == 0;
