% a) ----------------------------------------------------------------------------

f = @(n)(exp(j*pi*n/2));
resultado = sum(f([0:9]))
resultado_polar = [abs(resultado) arg(resultado)]


% b) ----------------------------------------------------------------------------

% f es igual al del punto a)
resultado = sum(f([-2:7]))
resultado_polar = [abs(resultado) arg(resultado)]

% c) ----------------------------------------------------------------------------

f = @(n)( ((1/2).^n) .* exp(j*pi*n/2) );
resultado = sum(f([0:9]))
resultado_polar = [abs(resultado) arg(resultado)]

% d) ----------------------------------------------------------------------------

f = @(n)(cos(pi*n/2));
resultado = sum(f([0:9]))
resultado_polar = [abs(resultado) arg(resultado)]
