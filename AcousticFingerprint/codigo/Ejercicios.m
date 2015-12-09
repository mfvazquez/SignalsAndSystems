pkg load signal

fig = 1;
% -------------------------- Ejercicio 1 ----------------------------

info = audioinfo('../Musica/haggard.wav');
audio_doble = audioread('../Musica/haggard.wav');

audio = mean(audio_doble,2);
N = 265;
intervalo = info.Duration/info.TotalSamples;
figure(fig++);
plot(0:intervalo:(N-1)*intervalo ,audio(1:N));
grid
xlabel ('tiempo [s]');
ylabel ('Canal de audio');
print('../Imagenes/Ej1_canal.png','-dpng');

% player = audioplayer(audio, info.SampleRate);
% play(player);

% -------------------------- Ejercicio 2 -----------------------------

N = 256;
[S, f, t] = specgram(audio, N, info.SampleRate, N, 0);
S = 10*log10(abs(S).^2);
S = mean(S',length(f(:,1)));
figure(fig++);
plot(f,S);
grid
xlabel('frecuencia [Hz]');
ylabel('Densidad espectral de potencia [dB]');
print('../Imagenes/Ej2_densidad_frecuencias.png','-dpng');


% -------------------------- Ejercicio 3 -----------------------------
% Utilice un filtro FIR ya que tienen fase 
% lineal como pide el enunciado.
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
figure(fig++);
zplane(b);
xlabel('Parte Real');
ylabel('Parte Imaginaria');
print('../Imagenes/Ej3_polos_y_ceros.png','-dpng');

% Respuesta en frecuencia
[H, W] = freqz(b);
W = W.*10;

H_abs = abs(H);
H_arg = unwrap(arg(H));

figure(fig++);
subplot(2,1,1);
plot(W,H_abs);
grid
xlabel('Frecuencia [KHz]');
ylabel('Modulo de la Respuesta en frecuencia');
axis([0 Fs/(2*1000) 0 1.2]);
subplot(2,1,2);
plot(W, H_arg);
grid
xlabel('Frecuencia [KHz]');
ylabel('Fase de la Respuesta en frecuencia');
axis([0 Fs/(2*1000) -20 0]);
print('../Imagenes/Ej3_respuesta_en_frecuencia.png','-dpng');

% Respuesta al impulso

[x, t] = impz(b);
t = (t ./ Fs)*1000; % t es el sample time, lo divido por Fs 
				    % para obtener el tiempo y lo paso a mseg
figure(fig++);
stem(t,x);
grid
xlabel('Amplitud');
ylabel('Tiempo [ms]');
print('../Imagenes/Ej3_respuesta_al_impulso.png','-dpng');

% retardo de grupo

retardo_grupo = grpdelay(b) ./ Fs; % divido por Fs para pasarlo a tiempo
retardo_grupo = retardo_grupo .* 1000000; % lo paso a micro segundos

fprintf('retardo de grupo del filtro = %d\n',retardo_grupo(1));

figure(fig++);
plot(W, retardo_grupo);
grid
xlabel('Frecuencia [KHz]');
ylabel('Retardo de grupo [us]');
axis([0 20 997 998]);
print('../Imagenes/Ej3_retardo_de_grupo.png','-dpng');

% player = audioplayer(audio_muestreado, info.SampleRate/Divisor);
% play(player);

% -------------------------- Ejercicio 4 -----------------------------
% uso la ventana por defecto que es una hanning(N) y overlap de 0.5

% senial original
N = 256;
win = hamming(N);
[S1, F1, T1] = specgram(audio, N, Fs, win);
S1 = abs(S1).^2;
figure(fig++);
imagesc(T1, F1, 10*log10(S1)), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('../Imagenes/Ej4_espectrograma_original.png','-dpng');

% Senial filtrada
[S2, F2, T2] = specgram(y, N, Fs);
S2 = abs(S2).^2;
figure(fig++);
imagesc(T2, F2, 10*log10(S2)), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
print('../Imagenes/Ej4_espectrograma_filtrado.png','-dpng');

% -------------------------- Ejercicio 5 -----------------------------
% hago las 2 ventanas con el mismo orden que el filtro diseniado
% orden = 88
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

figure(fig++);
hold on
plot(f, fft_rec, 'b-');
plot(f, fft_ham, 'r-');
grid
xlabel('Frecuencia [Hz]');
ylabel('Densidad espectral de potencia [dB]');
legend('rectangular de orden 25','hamming de orden 25')
axis([0 Fs -100 0]);
print('../Imagenes/Ej5_comparacion_ventanas.png','-dpng');

% -------------------------- Ejercicio 6 ------------------------------
Divisor = 8;
Fs = info.SampleRate/Divisor;
N1 = 64;
N2 = 4096;
N3 = 8192;

% Ventana rectangular
% N1
win = rectwin(N1);
[S, F, T] = specgram(audio_muestreado, N1, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana rectangular de longitud 64');
print('../Imagenes/Ej6_espetrograma_rectangular_N=64.png','-dpng');


% con mas zoom
Fi = find(F >= 1500, 1, 'first');
figure(fig++);
imagesc(T(Ti:Tf), F(Fi:end), 10*log10(S(Fi:end,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana rectangular de longitud 64');
print('../Imagenes/Ej6_espetrograma_rectangular_zoom.png','-dpng');



% N2
win = rectwin(N2);
[S, F, T] = specgram(audio_muestreado, N2, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana rectangular de longitud 4096');
print('../Imagenes/Ej6_espetrograma_rectangular_N=4096.png','-dpng');


% N3
win = rectwin(N3);
[S, F, T] = specgram(audio_muestreado, N3, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana rectangular de longitud 8192');
print('../Imagenes/Ej6_espetrograma_rectangular_N=8192.png','-dpng');

% Ventana hamming

% N1
win = hamming(N1);
[S, F, T] = specgram(audio_muestreado, N1, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana hamming de longitud 64');
print('../Imagenes/Ej6_espetrograma_hamming_N=64.png','-dpng');

% con mas zoom

Fi = find(F>=1500, 1, 'first');
figure(fig++);
imagesc(T(Ti:Tf), F(Fi:end), 10*log10(S(Fi:end,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana hamming de longitud 64');
print('../Imagenes/Ej6_espetrograma_hamming_zoom.png','-dpng');


% N2
win = hamming(N2);
[S, F, T] = specgram(audio_muestreado, N2, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana hamming de longitud 4096');
print('../Imagenes/Ej6_espetrograma_hamming_N=4096.png','-dpng');


% N3
win = hamming(N3);
[S, F, T] = specgram(audio_muestreado, N3, Fs, win);
S = abs(S).^2;
Ti = find(T>=60,1,'first');
Tf = find(T>=80,1,'first');
figure(fig++);
imagesc(T(Ti:Tf), F, 10*log10(S(:,Ti:Tf))), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Ventana hamming de longitud 8192');
print('../Imagenes/Ej6_espetrograma_hamming_N=8192.png','-dpng');

% -------------------------- Ejercicio 7 -----------------------------

H = generar_huella(audio,info.SampleRate);
figure(fig++);
imagesc(H(:,1:20));
colormap(gray());
ylabel('Banda');
xlabel('Frame');
print('../Imagenes/Ej7_huella.png','-dpng');

