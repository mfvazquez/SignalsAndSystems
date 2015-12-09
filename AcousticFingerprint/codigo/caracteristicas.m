% funcion que devuelve las caracteristicas del espectrograma
% Pre: E debe ser una matriz
% Post: Retorna una matriz E que contiene 1 o 0

function F = caracteristicas(E)

N = length(E(1,:));
M = length(E(:,1));

for m = 1:M-1
  for n = 2:N
    if( E(m,n) - E(m+1,n) > E(m,n-1) - E(m+1,n-1) )
      F(m,n-1) = 1;
    else 
      F(m,n-1) = 0;
    endif
   endfor  
endfor

endfunction