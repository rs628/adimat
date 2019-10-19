

X=linspace(0,10,11);
x=X;
Jac = admDiffFor(@myfunction, 1, x);


%x=linspace(1,10,10);
z=2.*x+2 ;
%jac giveds J*S
% Jac=jacobian matrix
% S=seed matrix
% here S is identity matrix
y=myfunction(x);
plot(x,y,'b')
%hold on
 plot(x,z,'*')
hold on
%clc
plot(x,Jac,'o')
