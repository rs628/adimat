% function [a_A U S V] = a_svd_001(a_V, A)
%
% Compute adjoint of A in [ U S V ] = svd(A), where a_V is the adjoint
% of V.
%
% Using the method from Mike Giles, "An extended collection of matrix
% derivative results for forward and reverse mode algorithmic
% differentiation", 2008, adding in the homework that was left to
% do there.
%
% Copyright 2012,2013 Johannes Willkomm, Institute for Scientific Computing   
%                     TU Darmstadt
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!

function [a_A U S V] = a_svd_001(a_V, A)

  [m, n] = size(A);
  broad = m <= n;
  
  % if abs(n - m) > 1
  %   warning('adimat:rev:svd', ...
  %           ['when the dimensions differ by more than one (m=%d, n=%d), it is not ' ...
  %            'yet sure that the computed derivative is correct'], m, n);
  % end
  
  [U S V] = svd(A);
  
  diagS1 = adimat_safediag(S);
    
  F = d_eig_F(diagS1.^2);
    
  if broad 
  
    S1 = S(1:m, 1:m);
    emS1 = repmat(diagS1, [1 m]);
    
    a_D = V.' * a_V;

    a_D1 = a_D(1:m, 1:m);
    a_D2 = -a_D(1:m, m+1:end) + a_D(m+1:end, 1:m).';
    %  a_D3 = a_D(m+1:end, m+1:end);
    
    a_D1F = a_D1 .* F;
    
    a_P1 =        emS1 .* a_D1F;
    a_P1 = a_P1 + emS1 .* a_D1F.';
    
    % a_P2 = inv(S1).' * a_D2;
    a_P2 = a_D2;
    neqz = diagS1 ~= 0;
    a_P2(neqz,:) = a_D2(neqz,:) ./ repmat(diagS1(neqz), [1 n-m]);
    
    a_P = [a_P1 a_P2];
    
    a_A = U * a_P * V.';

  else
    
    S1 = S(1:n, 1:n);
    emS1 = repmat(diagS1.', [n 1]);

    a_C = V.' * a_V;

    a_CF = a_C .* F;
    
    a_P1 =        emS1 .* a_CF;
    a_P1 = a_P1 + emS1 .* a_CF.';
    
    a_P = [a_P1 a_zeros(zeros(n, m-n))];
    
    a_A = U * a_P.' * V.';

  end

end
