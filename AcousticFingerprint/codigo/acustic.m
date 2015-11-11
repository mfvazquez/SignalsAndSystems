% -------------------------- Ejercicio 1 ---------------------------------------

info = audioinfo("audios/caprici_di_diablo.wav");
audio_doble = audioread("audios/caprici_di_diablo.wav");

audio = mean(audio_doble,2);
 
intervalo = info.Duration/info.TotalSamples;
figure 1
plot(0:intervalo:249*intervalo ,audio(1:250));
xlabel ("tiempo [s]");
ylabel ("Canal de audio");
print('canal.png','-dpng');

%player = audioplayer(audio, info.SampleRate);
%play(player);

% -------------------------- Ejercicio 2 ---------------------------------------
N = 5000;
[S, f, t] = specgram(audio, N, info.SampleRate);
S = 10*log10(abs(S).^2);
S = mean(S',length(f(:,1)));

fft_S = fft(audio);
fft_S = 10*log10(abs(fft_S).^2);

figure 2
plot(f(1,:),S(1,:));

xlabel("frecuencia [Hz]");
ylabel("Densidad de potencia");
print('densidad_frecuencias.png','-dpng');

figure 3
plot(fft_S);
