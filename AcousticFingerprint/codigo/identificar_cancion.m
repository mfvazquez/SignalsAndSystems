function identificar_cancion(archivo)

pkg load signal
if (exist('DB_v01.mat') != 2)
  generar_DB;
endif;
load DB_v01;

H = generar_huella_arch(archivo);
resultados = query_DB(DB,H);

fprintf('Resultados:\n');

for x = 1:length(resultados)
  cancion = files(resultados(x)).name;
  info = audioinfo(strcat('../Musica/',cancion));
  fprintf('%d -\n',x);
  fprintf('Cancion: %s\n', info.Title);
  fprintf('Artista: %s\n', info.Artist);
  fprintf('Duracion: %d\n\n', info.Duration);
  
endfor



endfunction;