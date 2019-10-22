

X=linspace(0,10,11);
x=X;
Jac1 = admDiffFor(@myfunction, 1, x); Jac = admDiffRev(@myfunction, 1, x);
z=2.*x+2 ;
%jac gives J*S
% Jac=jacobian matrix
% S=seed matrix
% here S is identity matrix
y=myfunction(x);
plot(x,y,'r')
hold on
plot(x,z,'b')
hold on
plot(x,Jac1,'g')
plot(x,Jac1,'m')


