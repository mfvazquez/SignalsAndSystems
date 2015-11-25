function H = generar_huella(archivo)

pkg load signal

info = audioinfo(archivo);
audio_doble = audioread(archivo);
audio = mean(audio_doble,2);

% Utilice un filtro FIR ya que tienen fase lineal como pide el enunciado.
% El maximo orden posible sin que el retardo supere los 1ms es 88.
Divisor = 8;
Fs = info.SampleRate;
orden = 88; % retardo de 997.7 us
Fc = 1750;
flag  = 'scale';         % Sampling Flag

win = hamming(orden+1);
b  = fir1(orden, Fc/(Fs/2), 'low', win, flag);
y = filter(b, 1, audio);
audio_muestreado = y(1:Divisor:end);
Fs = Fs/Divisor;

%win = ceil(Fs);
%noverlap = win - floor((Fs - 25)/2);


%window=ceil(Fs/25);
%step=ceil(window/4);
N = 64;
Noverlap = ceil((N - 25)/2);
[S, F, T] = specgram(audio_muestreado, N, Fs, N, Noverlap);
S = abs(S).^2;

frec_log = logspace(2.48,3.3,21);
S_log(1:21,1:length(T)) = 0;
F_log(1:21) = 0;
for i = 1:21
  x = find(F > frec_log(i), 1, 'first');
  F_log(i) = F(x);
  S_log(i,:) = S(x,:);
endfor

carac = caracteristicas(S_log);
figure;
imagesc(carac), axis xy
H = carac;

endfunction