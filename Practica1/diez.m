% 10) ------------------------------------------------------------------

function resultado = diez(n, x)

y1 = @(n)(x(2*n));
y2 = @(n)(x(n/2).*(rem(n,2)==0) + 0);

resultado = [y1(n);y2(n)];

return

endfunction
