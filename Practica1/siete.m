% a) -------------------------------------------------------------------

t = 0:0.01:2;
x = @(t)(t.*(t>=0).*(t<=1) + (2-t).*(t>1).*(t<=2) + 0);

figure 1
plot(t,x(t),'Linewidth',2)
axis ([-3 3 -2 2]);
grid


t = -2:0.01:2;
par = @(t)(0.5.* (x(t) + x(-t)));
impar = @(t)(0.5.* (x(t) - x(-t)));

figure 2
hold on
plot(t,par(t),'b','Linewidth',2)
plot(t,impar(t),'r','Linewidth',1)
axis ([-3 3 -2 2]);
legend("par", "impar");
grid

% b) -------------------------------------------------------------------

t = -2:0.01:2;
x = @(t)((t+2).*(t>=-2).*(t<-1) + (-t).*(t>=-1).*(t<0) + t.*(t>=0).*(t<1) + 1.*(t>=1).*(t<=2) + 0);

figure 3
plot(t,x(t),'Linewidth',2)
axis ([-3 3 -2 2]);
grid


par = @(t)(0.5.* (x(t) + x(-t)));
impar = @(t)(0.5.* (x(t) - x(-t)));

figure 4
hold on
plot(t,par(t),'b','Linewidth',2)
plot(t,impar(t),'r','Linewidth',1)
axis ([-3 3 -2 2]);
legend("par", "impar");
grid


% c) -------------------------------------------------------------------

t = -1:0.01:2;
x = @(t)((-2*t).*(t>=-1).*(t<0) + t.*(t>=0).*(t<=2) + 0);

figure 5
plot(t,x(t),'Linewidth',2)
axis ([-3 3 -2 2]);
grid


t = -2:0.01:2;
par = @(t)(0.5.* (x(t) + x(-t)));
impar = @(t)(0.5.* (x(t) - x(-t)));

figure 6
hold on
plot(t,par(t),'b','Linewidth',2)
plot(t,impar(t),'r','Linewidth',1)
axis ([-3 3 -2 2]);
legend("par", "impar");
grid
