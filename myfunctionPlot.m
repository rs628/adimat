x=1:0.05:10;
y=myfunction;
z=2.*x+2;
plot(x,y,'b')
hold on
plot(x,z,'r')
hold on
%[J ,out] = admDiffFor(@myautofunction,1, x);
