function [audio, Fs] = obtener_audio(archivo)

info = audioinfo(archivo);
Fs = info.SampleRate;

audio = audioread(archivo);
if (length(audio(1,:) > 1))
  audio = mean(audio,2);
endif


endfunction