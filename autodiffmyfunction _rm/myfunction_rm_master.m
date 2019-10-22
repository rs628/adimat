x=linspace(1,10,10);
y=myfunction_rm(x);
jac_rm=admDiffRev(@myfunction_rm, 1, x);
plot(x,y,'r')
hold on
plot(x,jac_rm)
hold on
z=2.*x+2;
plot(x,z,'*')
hold on