% generar_DB.m
%
% Este script recorre todos los archivos de audio ubicados en la carpeta
% path_in, extrae las huellas digitales acusticas de cada uno y las va
% guardando en la base de datos DB. Adapte este script segun crea necesario
% para utilizar su implementacion de la funcion generar_huella().
%
% 66.74 Senales y Sistemas, 2do cuat 2015 - FIUBA


% Carpeta donde estan mis archivos de audio
path_in = '../Musica/';
files = dir([path_in,'/*.wav']);  % Estructura con info de cada archivo


%% Analisis de las canciones

% Incializo tabla hash
% Tamanio en memoria para hash de 20 bits: 4MB x N_columnas
DB.hash_nbits = 20;     % Cantidad de bits de los hashes
DB.n_entries = 20;      % Cantidad de columnas de la tabla
DB.ID_nbits = 12;       % Cantidad de bits para ID numerico de la cancion
DB.tabla = zeros(2^DB.hash_nbits,DB.n_entries,'uint32');

for k=1:length(files)
    file = files(k).name;           % Nombre del archivo de audio
    path_file = [path_in,file];     % Path completo al archivo
    
    % Muestro por consola el archivo que analizamos
    fprintf('%d de %d: %s\n',k,length(files),file);
    
    % Generamos la huella acustica H
    % *************************************************
    % ADAPTE ESTA LINEA PARA EJECUTAR SU IMPLEMENTACION
    % *************************************************
    H = generar_huella(path_file);
    
    % Guardamos la huella en la DB. A esta cancion se asigna el
    % identificador numerico k, el cual se guarda en la base de datos
    % La matriz H debera ser una matriz con elementos binarios de
    % hash_nbits filas
    DB = guardar_huella(uint32(k),H,DB);
end

% Guardamos la base de datos generada
save('DB_v01.mat','DB')

