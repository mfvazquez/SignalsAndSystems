function H = generar_huella(audio, Fs)

% Utilice un filtro FIR ya que tienen fase lineal como pide el enunciado.
% El maximo orden posible sin que el retardo supere los 1ms es 88.
Divisor = 8;
orden = 88; % retardo de 997.7 us
Fc = 1750;
flag  = 'scale';         % Sampling Flag

win = hamming(orden+1);
b  = fir1(orden, Fc/(Fs/2), 'low', win, flag);
y = filter(b, 1, audio);
audio_muestreado = y(1:Divisor:end);
Fs = Fs/Divisor;

N = 2048;
Noverlap = ceil(N-(Fs/25));
[S, F, T] = specgram(audio_muestreado, N, Fs, N, Noverlap);
S = abs(S).^2;

frec_log = logspace(log10(300),log10(2000),22);
S_log(1:21,1:length(T)) = 0;
F_log(1:21) = 0;
for i = 1:21
  x = find(F > frec_log(i) & F < frec_log(i+1), 1, 'first');
  F_log(i) = F(x);
  S_log(i,:) = S(x,:);
endfor


H = caracteristicas(S_log);

endfunction