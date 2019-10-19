function res= horzcat(varargin)
%MADDERIV/HORZCAT Concatenate gradients horizontally
%
% Copyright 2001-2005 Andre Vehreschild, Institute for Scientific Computing
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!

if nargin==1
   res=varargin{1};
elseif nargin==2 % Faster, because no reallocation occurs.
   if isempty(varargin{1})
      res= varargin{2};
      return;
   end
   if isempty(varargin{2})
      res= varargin{1};
      return;
   end
   if ~(isa(varargin{1}, 'mexadderiv') && isa(varargin{2}, 'mexadderiv'))
      error('Both arguments of a horizontal matrix concatenation have to be mexadderivs.');
   end;

   % Now we can be sure, that the varargs are mexadderiv objects.
   if all(varargin{1}.sz==0)
      res= varargin{2};
      return;
   end
   if all(varargin{2}.sz==0)
      res= varargin{1};
      return;
   end

   res= varargin{1};

   res.sz(2)= res.sz(2)+varargin{2}.sz(2);
   destshape= res.sz.* res.ndd;
   res.deriv= cond_sparse(reshape(cat(2, ...
            reshape(full(varargin{1}.deriv), [varargin{1}.sz, varargin{1}.ndd]), ...
            reshape(full(varargin{2}.deriv), [varargin{2}.sz, varargin{2}.ndd])), ...
            destshape));
else
   % Lookup the first non-empty entry of the varargin. Empty entries are ignored.

   notempty= ~ cellfun('isempty', varargin);
   work= {varargin{notempty}};
   if ~ all(cellfun('isclass', work, 'mexadderiv'))
      error('All arguments of a horizontal matrix concatenation have to be mexadderivs.');
   end

   derivarr= cell(1, length(work));
   sz= 0;
   for iter= 1: length(work)
      derivarr{iter}= reshape(full(work{iter}.deriv), ...
            [work{iter}.sz, work{iter}.ndd]);
      sz= sz+ work{iter}.sz(2);
   end
   res= mexadderiv(work{1}.ndd, [], 'empty');
   res.sz= [work{1}.sz(1), sz];
   res.deriv= cond_sparse(reshape(cat(2, ...
       derivarr{~ cellfun('isempty', derivarr)}), res.sz.*res.ndd));
end

