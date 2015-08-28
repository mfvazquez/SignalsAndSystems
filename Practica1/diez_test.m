% Prueba del ejercicio 10) ---------------------------------------------

n = -5:20;
x = @(n)(n.*(n>=0)+0);

y = feval("diez",n,x);

y1 = y(1,:);
y2 = y(2,:);

figure 1
stem(n,x(n), 'b', 'Linewidth',3)
ylabel('x');
xlabel('n');
axis ([-5 20 0 40]);
grid

figure 2
stem(n,y1, 'r', 'Linewidth',3)
ylabel('y1');
xlabel('n');
axis ([-5 20 0 40]);
grid

figure 3
stem(n,y2, 'g', 'Linewidth',3)
ylabel('y2');
xlabel('n');
axis ([-5 20 0 40]);
grid
