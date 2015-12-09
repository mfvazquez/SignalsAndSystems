function H = generar_huella_arch(archivo)
pkg load signal

[audio, Fs] = obtener_audio(archivo);
H = generar_huella(audio, Fs);

endfunction