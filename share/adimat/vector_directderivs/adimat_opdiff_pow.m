% function r = adimat_opdiff_pow(d_val1, val1, d_val2, val2)
%
% Copyright 2010,2011 Johannes Willkomm, Institute for Scientific Computing
%                     RWTH Aachen University
%
% This file is part of the ADiMat runtime environment
%
function r = adimat_opdiff_pow(d_val1, val1, d_val2, val2)

  if isscalar(val1) && isscalar(val2)
    r = d_val1 .* (val2 * val1 ^ (val2 - 1)) ...
        + d_val2 .* (log(val1) * val1 ^ val2);

  elseif isscalar(val2)

    if val2 == 1
      loga = logm(full(val1));
      d_ex = adimat_opdiff_emult_right(d_val2, val2, loga);
      ex = val2 .* loga;
      s = adimat_diff_expm(d_ex, ex);
      r = d_val1 + s;

    elseif isreal(val2) && mod(val2, 1) == 0 && val2 > 1

      r = adimat_opdiff_mult_right(d_val1, val1, (val1^(val2-1)));
      for i=1:val2-1
        tmp = adimat_opdiff_mult_left(val1^i, d_val1, val1);
        r = r + adimat_opdiff_mult_right(tmp, val1, val1^(val2-i-1));
      end

      % + derivatives w.r.t. b
      % compute a^b as expm(b * logm(a))
      loga = logm(full(val1));
      d_ex = adimat_opdiff_emult_right(d_val2, val2, loga);
      ex = val2 .* loga;
      s = adimat_diff_expm(d_ex, ex);

      r = r + s;
    
    else
      % compute a^b as expm(b * logm(a))
      [d_loga loga] = adimat_diff_logm(d_val1, val1);
      d_ex = adimat_opdiff_emult(d_val2, val2, d_loga, loga);
      ex = val2 .* loga;
      r = adimat_diff_expm(d_ex, ex);
    
    end
  elseif isscalar(val1)
    % compute a^b as expm(b * log(a))
    [d_loga loga] = adimat_diff_log(d_val1, val1);
    d_ex = adimat_opdiff_emult(d_val2, val2, d_loga, loga);
    ex = val2 .* loga;
    r = adimat_diff_expm(d_ex, ex);
  
  else
    error('adimat:adimat_opdiff_pow', '%s', ...
          'A^B, where both X and Y are matrices, is not allowed in Matlab');
  end

% $Id: adimat_opdiff_pow.m 3309 2012-06-18 09:53:52Z willkomm $
