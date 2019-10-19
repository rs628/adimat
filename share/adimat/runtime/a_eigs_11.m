% function a_A = a_eigs_11_31(a_U, a_D, A, k?, sigma?)
%
% Compute adjoint of A in [V D] = eig(A), given adjoints of V and D.
%
% This file is part of the ADiMat runtime environment
%
% Copyright (C) 2015 Johannes Willkomm
function a_A = a_eigs_11(a_U, a_D, A, varargin)
  [V D U] = adimat_lreigs(A, varargin{:});
  k = size(U,2);
  I = eye(size(A));
  a_A = a_zeros(A);
  for i=1:k
    d = D(i,i);
    B = A - d .* I + U(:,i) * V(i,:);
    a_B = B.' \ (a_U(:,i) * -U(:,i).');
    a_A = a_A + a_B;
    a_D(i,i) = a_D(i,i) - call(@sum, call(@diag, a_B));
  end
  a_A = a_A + V.' * call(@diag,call(@diag,a_D)) * U.';
