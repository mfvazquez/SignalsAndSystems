pkg load signal
% -------------------------- Ejercicio 1 ---------------------------------------

info = audioinfo("audios/caprici_di_diablo.wav");
audio_doble = audioread("audios/caprici_di_diablo.wav");

audio = mean(audio_doble,2);
 
intervalo = info.Duration/info.TotalSamples;
figure 1
N = 265;
plot(0:intervalo:(N-1)*intervalo ,audio(1:N));
xlabel ("tiempo [s]");
ylabel ("Canal de audio");
print('canal_cdd.png','-dpng');

%player = audioplayer(audio, info.SampleRate);
%play(player);

% -------------------------- Ejercicio 2 ---------------------------------------

N = 512;
window(1:N-1) = 1;
[S, f, t] = specgram(audio, N, info.SampleRate, N, 0);
S = 10*log10(abs(S).^2);
S = mean(S',length(f(:,1)));

fft_S = fft(audio);
fft_S = 10*log10(abs(fft_S).^2);

figure 2
plot([-f(1,end:-1:1),f(1,:)],[S(end:-1:1),S(1,:)]);

xlabel("frecuencia [Hz]");
ylabel("Densidad de potencia");
print('densidad_frecuencias_cdd.png','-dpng');

% -------------------------- Ejercicio 3 ---------------------------------------