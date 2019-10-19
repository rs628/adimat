% function [g_V, V, g_D, D]= g_eigs2(g_A, A, k?, sigma?, opts?)
%
% This file is part of the ADiMat runtime environment
%
% Copyright (C) 2018 Johannes Willkomm
% Copyright (C) 2015 Johannes Willkomm
function [g_U, U, g_D, D] = g_eigs2(g_A, A, varargin)
  ws = warning('query');
  warning('off', 'MATLAB:nearlySingularMatrix');
  [V D U] = adimat_lreigs(A, varargin{:});

  k = size(U, 2);
  I = eye(size(A));
  
  g_U = g_zeros(size(U));
  g_D = g_zeros(size(D));

  for i=1:k
    lambda = D(i,i);
    uk = U(:,i);
    vk = V(i,:);
    
    dd = vk * (g_A * uk);
    g_D(i,i) = dd;
    
    r1 = - ( g_A - dd .* I ) * uk;
    Z = A - lambda.*I + uk * vk;
    g_U(:,i) = Z \ r1;
  end
  warning(ws);
