clc;
clear;
X=linspace(0,10,11);
x=X;
Jactest1 = admDiffFor(@mytest, 1, x);
%Jactest2 = admDiffRev(@myfunction, 1, x);
z=2.*x;
%jac gives J*S
% Jac=jacobian matrix
% S=seed matrix
% here S is identity matrix
w=mytest(x);
plot(x,w,'r')
hold on
plot(x,z,'g')
hold on
plot(x,Jactest1,'.')
hold on
%plot(x,Jactest2,'*')
