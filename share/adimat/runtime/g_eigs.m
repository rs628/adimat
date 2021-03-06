% function [g_l, l]= g_eigs(g_A, A)
%
% This file is part of the ADiMat runtime environment
%
% Copyright (C) 2018 Johannes Willkomm
% Copyright (C) 2015 Johannes Willkomm
function [g_l, l]= g_eigs(g_A, A, varargin)
  l = eigs(A, varargin{:});
  [V D U] = adimat_lreigvs(A, l);
  g_l = sum(V.' .* (g_A * U), 1);
  g_l = reshape(g_l, size(l));
