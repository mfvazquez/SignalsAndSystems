function resultado = cuatro(N,A)

	n = [-2*N:2*N];
	x = zeros(1,4*N+1);
	x([2*N+1:3*N]) = A;
	figure
	stem(n,x,'bo','Linewidth',2)
	grid
	axis ([-2*N 2*N -1 2])
	 
endfunction
