% d) -------------------------------------------------------------------

f = @(n) ( 1 .*(0<=n) .*(n<=10) + (2-n/10) .*(10<n) .*(n<=20) + 0 .* (n<0) .*(n>20));
n = [-25:50];
figure 1
stem(n, f(n),'Linewidth',2)
grid
axis ([-5 25 0 1.5])

% a) -------------------------------------------------------------------

figure 2
stem(n, f(3*n/2 +1),'Linewidth',2)
grid
axis ([-5 15 0 1.5])

% b) -------------------------------------------------------------------

figure 3
stem(n, f(-2*n-1),'Linewidth',2)
grid
axis ([-15 5 0 1.5])

% c) -------------------------------------------------------------------

figure 4
stem(n, f(n/2 -1/2),'Linewidth',2)
grid
axis ([-5 50 0 1.5])
