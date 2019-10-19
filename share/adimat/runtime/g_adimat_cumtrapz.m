% Generated by ADiMat 0.6.0-4867
% Copyright 2009-2013 Johannes Willkomm, Fachgebiet Scientific Computing,
% TU Darmstadt, 64289 Darmstadt, Germany
% Copyright 2001-2008 Andre Vehreschild, Institute for Scientific Computing,
% RWTH Aachen University, 52056 Aachen, Germany.
% Visit us on the web at http://www.adimat.de
% Report bugs to adimat-users@lists.sc.informatik.tu-darmstadt.de
%
%
%                             DISCLAIMER
%
% ADiMat was prepared as part of an employment at the Institute
% for Scientific Computing, RWTH Aachen University, Germany and is
% provided AS IS. NEITHER THE AUTHOR(S), THE GOVERNMENT OF THE FEDERAL
% REPUBLIC OF GERMANY NOR ANY AGENCY THEREOF, NOR THE RWTH AACHEN UNIVERSITY,
% INCLUDING ANY OF THEIR EMPLOYEES OR OFFICERS, MAKES ANY WARRANTY,
% EXPRESS OR IMPLIED, OR ASSUMES ANY LEGAL LIABILITY OR RESPONSIBILITY
% FOR THE ACCURACY, COMPLETENESS, OR USEFULNESS OF ANY INFORMATION OR
% PROCESS DISCLOSED, OR REPRESENTS THAT ITS USE WOULD NOT INFRINGE
% PRIVATELY OWNED RIGHTS.
%
% Global flags were:
% FORWARDMODE -- Apply the forward mode to the files.
% NOOPEROPTIM -- Do not use optimized operators. I.e.:
%		 g_a*b*g_c -/-> mtimes3(g_a, b, g_c)
% NOLOCALCSE  -- Do not use local common subexpression elimination when
%		 canonicalizing the code.
% NOGLOBALCSE -- Prevents the application of global common subexpression
%		 elimination after canonicalizing the code.
% NOPRESCALARFOLDING -- Switch off folding of scalar constants before
%		 augmentation.
% NOPOSTSCALARFOLDING -- Switch off folding of scalar constants after
%		 augmentation.
% NOCONSTFOLDMULT0 -- Switch off folding of product with one factor
%		 being zero: b*0=0.
% FUNCMODE    -- Inputfile is a function (This flag can not be set explicitly).
% NOTMPCLEAR  -- Suppress generation of clear g_* instructions.
% UNBOUND_ERROR	-- Stop with error if unbound identifiers found (default).
% VERBOSITYLEVEL=4
% AD_IVARS= a, b
% AD_DVARS= z

% function z = adimat_cumtrapz(varargin)
%
% ADiMat replacement function for cumtrapz
%
% Copyright (C) 2015 Johannes Willkomm
function [g_z, z]= g_adimat_cumtrapz(g_a, a, g_b, b, c)
   narginmapper_00000= [0, 1, 0, 2, 3];
   if narginmapper_00000(nargin)== 1% trapz(Y)
      [g_z, z]= g_adimat_cumtrapz_uni1(g_a, a); 
   elseif narginmapper_00000(nargin)== 2
      if isscalar(b)% trapz(Y, dim)
         [g_z, z]= g_adimat_cumtrapz_uni2(g_a, a, g_b, b); 
      else 
         % trapz(X, Y)
         [g_z, z]= g_adimat_cumtrapz_nonuni2(g_a, a, g_b, b); 
      end
   else 
      % trapz(X, Y, dim)
      [g_z, z]= g_adimat_cumtrapz_nonuni3(g_a, a, g_b, b, c); 
   end
end

function [g_z, z]= g_adimat_cumtrapz_uni1(g_Y, Y)
   dim= adimat_first_nonsingleton(Y); 
   [g_z, z]= g_adimat_cumtrapz_uni2(g_Y, Y, g_zeros(size(dim)), dim); 
end

function [g_z, z]= g_adimat_cumtrapz_uni2(g_Y, Y, g_dim, dim)
   len= size(Y, dim); 
   if len< 2
      z= zeros(size(Y)); 
      g_z= g_zeros(size(z));
   else 
      inds= repmat({':'}, [length(size(Y)), 1]); 
      inds{dim}= 1: len- 1; 
      g_tmp_Y_00000= g_Y(inds{: });
      tmp_Y_00000= Y(inds{: });
      g_Y1= g_tmp_Y_00000;
      Y1= tmp_Y_00000; 
      inds{dim}= 2: len; 
      g_tmp_Y_00001= g_Y(inds{: });
      tmp_Y_00001= Y(inds{: });
      g_Y2= g_tmp_Y_00001;
      Y2= tmp_Y_00001; 
      g_tmp_cumsum_00000= call(@cumsum, g_Y1, dim);
      tmp_cumsum_00000= cumsum(Y1, dim);
      g_tmp_cumsum_00001= call(@cumsum, g_Y2, dim);
      tmp_cumsum_00001= cumsum(Y2, dim);
      g_tmp_adimat_cumtrapz_uni2_00000= g_tmp_cumsum_00000+ g_tmp_cumsum_00001;
      tmp_adimat_cumtrapz_uni2_00000= tmp_cumsum_00000+ tmp_cumsum_00001;
      g_z= 0.5.* g_tmp_adimat_cumtrapz_uni2_00000;
      z= 0.5.* tmp_adimat_cumtrapz_uni2_00000; 
      sy= size(Y); 
      sy(dim)= 1; 
      g_tmp_adimat_cumtrapz_uni2_00001= cat(dim, g_zeros(size(zeros(sy))), g_z);
      tmp_adimat_cumtrapz_uni2_00001= cat(dim, zeros(sy), z); 
      % Update detected: z= some_expression(z,...)
      g_z= g_tmp_adimat_cumtrapz_uni2_00001;
      z= tmp_adimat_cumtrapz_uni2_00001;
   end
end

function [g_z, z]= g_adimat_cumtrapz_nonuni2(g_X, X, g_Y, Y, dim)
   dim= adimat_first_nonsingleton(Y); 
   [g_z, z]= g_adimat_cumtrapz_nonuni3(g_X, X, g_Y, Y, dim); 
end

function [g_z, z]= g_adimat_cumtrapz_nonuni3(g_X, X, g_Y, Y, dim)
   len= size(Y, dim); 
   if len< 2
      z= zeros(size(Y)); 
      g_z= g_zeros(size(z));
   else 
      ndim= length(size(Y)); 
      g_D= call(@diff, g_X);
      D= diff(X); 
      a= 0; 
      b= sum(D); 
      N= len; 
      tmp_adimat_cumtrapz_nonuni3_00000= len- 1;
      tmp_adimat_cumtrapz_nonuni3_00001= [ones(1, dim- 1), tmp_adimat_cumtrapz_nonuni3_00000, ones(1, ndim- dim)];
      g_tmp_adimat_cumtrapz_nonuni3_00005= call(@reshape, g_D, tmp_adimat_cumtrapz_nonuni3_00001);
      tmp_adimat_cumtrapz_nonuni3_00005= reshape(D, tmp_adimat_cumtrapz_nonuni3_00001); 
      % Update detected: D= some_expression(D,...)
      g_D= g_tmp_adimat_cumtrapz_nonuni3_00005;
      D= tmp_adimat_cumtrapz_nonuni3_00005;
      sy1= size(Y); 
      sy1(dim)= 1; 
      g_tmp_adimat_cumtrapz_nonuni3_00006= call(@repmat, g_D, sy1);
      tmp_adimat_cumtrapz_nonuni3_00006= repmat(D, sy1); 
      % Update detected: D= some_expression(D,...)
      g_D= g_tmp_adimat_cumtrapz_nonuni3_00006;
      D= tmp_adimat_cumtrapz_nonuni3_00006;
      inds= repmat({':'}, [length(size(Y)), 1]); 
      inds{dim}= 1: len- 1; 
      g_tmp_Y_00002= g_Y(inds{: });
      tmp_Y_00002= Y(inds{: });
      g_Y1= g_tmp_Y_00002;
      Y1= tmp_Y_00002; 
      inds{dim}= 2: len; 
      g_tmp_Y_00003= g_Y(inds{: });
      tmp_Y_00003= Y(inds{: });
      g_Y2= g_tmp_Y_00003;
      Y2= tmp_Y_00003; 
      g_tmp_adimat_cumtrapz_nonuni3_00002= g_Y1.* D+ Y1.* g_D;
      tmp_adimat_cumtrapz_nonuni3_00002= Y1.* D;
      g_tmp_cumsum_00002= call(@cumsum, g_tmp_adimat_cumtrapz_nonuni3_00002, dim);
      tmp_cumsum_00002= cumsum(tmp_adimat_cumtrapz_nonuni3_00002, dim);
      g_tmp_adimat_cumtrapz_nonuni3_00003= g_Y2.* D+ Y2.* g_D;
      tmp_adimat_cumtrapz_nonuni3_00003= Y2.* D;
      g_tmp_cumsum_00003= call(@cumsum, g_tmp_adimat_cumtrapz_nonuni3_00003, dim);
      tmp_cumsum_00003= cumsum(tmp_adimat_cumtrapz_nonuni3_00003, dim);
      g_tmp_adimat_cumtrapz_nonuni3_00004= g_tmp_cumsum_00002+ g_tmp_cumsum_00003;
      tmp_adimat_cumtrapz_nonuni3_00004= tmp_cumsum_00002+ tmp_cumsum_00003;
      g_z= 0.5* g_tmp_adimat_cumtrapz_nonuni3_00004;
      z= 0.5* tmp_adimat_cumtrapz_nonuni3_00004; 
      g_tmp_adimat_cumtrapz_nonuni3_00007= cat(dim, g_zeros(size(zeros(sy1))), g_z);
      tmp_adimat_cumtrapz_nonuni3_00007= cat(dim, zeros(sy1), z); 
      % Update detected: z= some_expression(z,...)
      g_z= g_tmp_adimat_cumtrapz_nonuni3_00007;
      z= tmp_adimat_cumtrapz_nonuni3_00007;
   end
end

% $Id: adimat_cumtrapz.m 4860 2015-02-07 13:49:39Z willkomm $
