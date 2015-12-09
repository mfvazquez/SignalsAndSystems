[audio, Fs] = obtener_audio('../Musica/haggard.wav');

audio = audio(1:10*Fs);

N = 256;
[S, F, T] = specgram(audio, N, Fs);
S = abs(S).^2;
figure;
imagesc(T, F, 10*log10(S)), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Audio original');
print('../Imagenes/Ej14_espectrograma_audio_original.png','-dpng');

sat = sqrt(var(audio))*1.5;     
for x = 1:length(audio)
  if (audio(x) > sat)
    audio(x) = sat;
  elseif(audio(x) < -sat)
    audio(x) = -sat;
  endif
endfor

N = 256;
[S, F, T] = specgram(audio, N, Fs);
S = abs(S).^2;
figure;
imagesc(T, F, 10*log10(S)), axis xy
h = colorbar('EastOutside');
ytick = get(h, 'ytick');
set(h, 'yticklabel', sprintf('%g dB|', ytick));
ylabel('frecuencia [Hz]');
xlabel('Tiempo [seg.]');
title('Audio saturado');
print('../Imagenes/Ej14_espectrograma_audio_saturado.png','-dpng');