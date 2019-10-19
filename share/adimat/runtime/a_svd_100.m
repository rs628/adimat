% function [a_A U S V] = a_svd_100(a_U, A)
%
% Compute adjoint of A in [ U S V ] = svd(A), where a_U is the
% adjoints of U.
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

function [a_A U S V] = a_svd_100(a_U, A)
  
  [m, n] = size(A);
  broad = m <= n;
  
  [U S V] = svd(A);
  
  diagS1 = adimat_safediag(S);
    
  F = d_eig_F(diagS1.^2);
    
  if broad 
  
    S1 = S(1:m, 1:m);
    emS1 = repmat(diagS1.', [m 1]);

    a_C = U.' * a_U;

    a_CF = a_C .* F;
    
    a_P1 =        emS1 .* a_CF;
    a_P1 = a_P1 + emS1 .* a_CF.';
    
    a_P = [a_P1 a_zeros(zeros(m, n - m))];
    
    a_A = U * a_P * V.';

  else
    
    S1 = S(1:n, 1:n);
    emS1 = repmat(diagS1, [1 n]);

    a_D = U.' * a_U;

    a_D1 = a_D(1:n, 1:n);
    a_D2 = -a_D(1:n, n+1:end) + a_D(n+1:end, 1:n).';
    %  a_D3 = a_D(n+1:end, n+1:end);
    
    a_D1F = a_D1 .* F;
    
    a_P1 =        emS1 .* a_D1F;
    a_P1 = a_P1 + emS1 .* a_D1F.';
    
    % a_P2 = inv(S1).' * a_D2;
    a_P2 = a_D2;
    neqz = diagS1 ~= 0;
    a_P2(neqz,:) = a_D2(neqz,:) ./ repmat(diagS1(neqz), [1 m-n]);
    
    a_P = [a_P1 a_P2];
    
    a_A = U * a_P.' * V.';

  end

end
