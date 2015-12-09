function tests(T, agregar_ruido, SNR, saturar, ecualizar ,ralentizar)

pkg load signal
if (exist('DB_v01.mat') != 2)
  generar_DB;
endif;
load DB_v01

% Duracion de los segmentos de cada prueba
evaluaciones = 50;

aciertos1 = zeros(length(T),1);
aciertos5 = zeros(length(T),1);

for t=1:length(T)
  for i = 1: evaluaciones

    n = floor(rand*length(files)+1);
    archivo = strcat('../Musica/',files(n).name);
    [audio, Fs] = obtener_audio(archivo);
    segmento = Fs*T(t);
    inicio = floor(rand*(length(audio)-segmento+1));
    fin = inicio+segmento;
    audio = audio(inicio:fin);
    
    if (agregar_ruido)
      Px = var(audio);
      divisor = 10^(SNR/10);
      Pn = sqrt(Px/divisor)*randn(length(audio),1);
      audio = audio+Pn;    
    endif
    
    if (saturar)
      % saturacion      
      sat = sqrt(var(audio))*1.5;     
      for x = 1:length(audio)
        if (audio(x) > sat)
          audio(x) = sat;
        elseif(audio(x) < -sat)
          audio(x) = -sat;
        endif
      endfor
    endif
      
    if (ecualizar)
      % pasa altos
      orden = 200; % retardo de 997.7 us
      Fc = 1000;
      flag  = 'scale';         % Sampling Flag

      win = hamming(orden+1);
      b  = fir1(orden, Fc/(Fs/2), 'high', win, flag);
      audio = filter(b, 1, audio);
    endif
   
    if (ralentizar)
     % desacelera
      [audio, h] = resample(audio, Fs*0.99,Fs);    
    endif
    
    H = generar_huella(audio,Fs);
    resultado = query_DB(DB,H);
    
    if (resultado(1) == n)
      aciertos1(t) = 1 + aciertos1(t);
    endif
    
    if (length(find(resultado,n)) != 0)
      aciertos5(t) = 1 + aciertos5(t);
    endif
    
  endfor;  
endfor;

for i = 1:length(T)
  fprintf('Para T=%d\n',T(i));
  fprintf('Aciertos de primer puesto: %d\n', aciertos1(i));
  fprintf('Aciertos de primeros 5 puesto : %d\n', aciertos5(i));
endfor

endfunction