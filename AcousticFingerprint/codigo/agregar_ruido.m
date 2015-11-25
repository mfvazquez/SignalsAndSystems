function agregar_ruido(archivo, N)

pkg load signal

info = audioinfo(archivo);
audio_doble = audioread(archivo);
audio = mean(audio_doble,2);

for i = 1:length(audio)
  audio(i) = audio(i) + rand/N;
endfor

audiowrite('../ruidoso.wav', audio, info.SampleRate);

endfunction