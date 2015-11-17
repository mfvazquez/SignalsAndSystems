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
print('Ej1_canal.png','-dpng');

%player = audioplayer(audio, info.SampleRate);
%play(player);

% -------------------------- Ejercicio 2 ---------------------------------------

N = 512;
window(1:N-1) = 1;
[S, f, t] = specgram(audio, N, info.SampleRate, N, 0);
S = 10*log10(abs(S).^2);
S = mean(S',length(f(:,1)));

%fft_S = fft(audio);
%fft_S = 10*log10(abs(fft_S).^2);

figure 2
plot([-f(1,end:-1:1),f(1,:)],[S(end:-1:1),S(1,:)]);

xlabel("frecuencia [Hz]");
ylabel("Densidad de potencia");
print('Ej2_frecuencias.png','-dpng');

% -------------------------- Ejercicio 3 ---------------------------------------
Divisor = 8;
Fs = info.SampleRate/Divisor;  % Sampling Frequency

% Filtro con delay de grupo de 907 ms

Fstop = 250;            % Stopband Frequency
Fpass = 0;             % Passband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
flag  = 'scale';         % Sampling Flag
 
% Calculate the order from the parameters using KAISERORD.
[orden,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);
orden
% Calculate the coefficients using the FIR1 function.
b  = fir1(orden, Wn, TYPE, kaiser(orden+1, BETA), flag);


y = filter(b, 1, audio);
y = y(1:Divisor:end);

player = audioplayer(y, Fs);
play(player);

N = 512;
window(1:N-1) = 1;
[S, f, t] = specgram(y, N, Fs, N, 0);
S = 10*log10(abs(S).^2);
S = mean(S',length(f(:,1)));


figure 3
plot([-f(1,end:-1:1),f(1,:)],[S(end:-1:1),S(1,:)]);

xlabel("frecuencia [Hz]");
ylabel("Densidad de potencia filtrada");
print('Ej2_frecuencias_feas.png','-dpng');

% -------------------------- Ejercicio 4 ---------------------------------------
N = floor(info.TotalSamples/10);
N2 = floor(length(y)/10);
figure 4
specgram(audio, N, info.SampleRate);
figure 5
specgram(y, N2, Fs);