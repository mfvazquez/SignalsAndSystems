% a) ---------------------------------------------------------------------------

n = -4:4;
x = zeros(1,9);
x(3) = -2;

figure 1
stem(n,x,'bo','Linewidth',2)
grid

% b) ---------------------------------------------------------------------------

n = -3:3;
x = zeros(1,7);
for i = 4:7
  x(i) = 2^n(i);
endfor

figure 2
stem(n,x,'bo','Linewidth',2)
grid

% c) ---------------------------------------------------------------------------

n = -3:3;
x = zeros(1,7);
for i = 4:7
  x(i) = 2^-n(i);
endfor

figure 3
stem(n,x,'bo','Linewidth',2)
grid

% d) ---------------------------------------------------------------------------

n = -4:4;
x = zeros(1,9);
for i = 1:5
  x(i) = 2^-n(i);
endfor

figure 4
stem(n,x,'bo','Linewidth',2)
grid

% e) ---------------------------------------------------------------------------

n = 0:11;
x = zeros(1,12);
for i = 3:12
  x(i) = cos((pi/3)*n(i));
endfor

figure 5
stem(n,x,'bo','Linewidth',2)
grid
