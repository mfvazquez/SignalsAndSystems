pkg load signal

fig = 1;
% -------------------------- Ejercicio 1 ---------------------------------------

info = audioinfo('audios/haggard.wav');
audio_doble = audioread('audios/haggard.wav');

audio = mean(audio_doble,2);
N = 265;
intervalo = info.Duration/info.TotalSamples;
figure(fig++)
plot(0:intervalo:(N-1)*intervalo ,audio(1:N));
grid
xlabel ('tiempo [s]');
ylabel ('Canal de audio');
print('Ej1_canal.png','-dpng');

%player = audioplayer(audio, info.SampleRate);
%play(player);

% -------------------------- Ejercicio 2 ---------------------------------------

N = 512;
[S, f, t] = specgram(audio, N, info.SampleRate, N, 0);
S = 10*log10(abs(S).^2);

S = mean(S',length(f(:,1)));

figure(fig++)
plot(f,S);
grid
xlabel('frecuencia [Hz]');
ylabel('Densidad espectral de potencia [dB]');
print('Ej2_densidad_frecuencias.png','-dpng');

% -------------------------- Ejercicio 3 ---------------------------------------
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

% Diagrama de Polos y Ceros
figure(fig++)
zplane(b);
xlabel('Parte Real');
ylabel('Parte Imaginaria');
print('Ej3_polos_y_ceros.png','-dpng');

% Respuesta en frecuencia
[H, W] = freqz(b);
W = W.*10;

H_abs = abs(H);
H_arg = unwrap(arg(H));

figure(fig++)
subplot(2,1,1);
plot(W,H_abs);
grid
xlabel('Frecuencia [KHz]');
ylabel('Modulo de la Respuesta en frecuencia');
subplot(2,1,2);
plot(W, H_arg);
grid
xlabel('Frecuencia [KHz]');
ylabel('Fase de la Respuesta en frecuencia');
print('Ej3_respuesta_en_frecuencia.png','-dpng');

% retardo de grupo

retardo_grupo = grpdelay(b) ./ Fs; % divido por Fs para pasarlo a tiempo
retardo_grupo = retardo_grupo .* 1000000; % lo paso a micro segundos

figure(fig++)
plot(W, retardo_grupo);
grid
xlabel('Frecuencia [KHz]');
ylabel('Retardo de grupo [us]');
axis([0 20 997 998]);
print('Ej3_retardo_de_gruupo.png','-dpng');

%player = audioplayer(audio_muestreado, info.SampleRate/Divisor);
%play(player);

% -------------------------- Ejercicio 4 ---------------------------------------
% uso la ventana por defecto que es una hanning(N) y overlap de 0.5 con N = 1024

%señal original
N = 256;
[S1, F1, T1] = specgram(audio, N, Fs);
S1 = abs(S1).^2;
figure(fig++)
imagesc(T1, F1, 10*log10(S1)), axis xy
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('Ej4_espectrograma_original.png','-dpng');

% Señal filtrada
[S2, F2, T2] = specgram(y, N, Fs);
S2 = abs(S2).^2;
figure(fig++)
imagesc(T2, F2, 10*log10(S2)), axis xy
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('Ej4_espectrograma_filtrado.png','-dpng');

% -------------------------- Ejercicio 5 ---------------------------------------
% hago las 2 ventanas con el mismo orden que el filtro diseñado, orden = 88
Fs = 44100;
Fc = 1750;
N = 25;
M = floor((Fs*N)/Fc);
f = 0:Fs/M:Fs;

% ventana rectangular
win_rec = rectwin(N+1);
fft_rec = fft(win_rec, M+1);
fft_rec = abs(fft_rec).^2;
fft_rec = fft_rec ./fft_rec(1);
fft_rec = 10*log10(fft_rec);

% ventana hamming
win_ham = hamming(N+1);
fft_ham = fft(win_ham, M+1);
fft_ham = abs(fft_ham).^2;
fft_ham = fft_ham ./fft_ham(1);
fft_ham = 10*log10(fft_ham);

figure(fig++)
hold on
plot(f, fft_rec, 'b-');
plot(f, fft_ham, 'r-');
grid
xlabel('Frecuencia [Hz]');
ylabel('Densidad espectral de potencia [dB]');
legend('rectangular de orden 25','hamming de orden 25')
axis([0 Fs/2 -100 0]);
print('Ej5_comparacion_ventanas.png','-dpng');

% -------------------------- Ejercicio 6 ---------------------------------------

% Ventana rectangular
Divisor = 8;
Fs = info.SampleRate;
orden = 88; % retardo de 997.7 us
Fc = 1750;
flag  = 'scale';         % Sampling Flag

win = rectwin(orden+1);
b  = fir1(orden, Fc/(Fs/2), 'low', win, flag);
y = filter(b, 1, audio);

audio_muestreado_rec = y(1:Divisor:end);

Fs = 5512.5;
N = 256;
[S, F, T] = specgram(audio_muestreado_rec, N, Fs);
S = abs(S).^2;
figure(fig++)
imagesc(T, F, 10*log10(S)), axis xy
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('Ej6_espetrograma_rectangular.png','-dpng');

% señal sub-muestreada


[S, F, T] = specgram(audio_muestreado, N, Fs);
S = abs(S).^2;
figure(fig++)
imagesc(T, F, 10*log10(S)), axis xy
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('Ej6_espetrograma_hamming.png','-dpng');