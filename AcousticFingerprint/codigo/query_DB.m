function [ID,MATCHES] = query_DB(DB,huella)
pkg load communications
%[ID,MATCHES] = query_DB(DB,HUELLA)
%
% Hace un query a la base de datos para obtener el ID de las canciones
% coincidentes con la HUELLA. Devuelve los 5 primeros resultados que mejor
% coinciden, ordenados en orden de prioridad descendente.
%
% Inputs:
%   DB: estructura con los siguientes campos
%       - hash_nbits: numero de bits para el hash
%       - n_entries: numero de columnas de la tabla
%       - ID_nbits: numero de bits para guardar ID numerico de la cancion
%       - tabla: tabla hash de 2^hash_nbits filas x n_entries columnas
%   HUELLA: huella acustica en forma de matriz binaria (1 y 0)
%
% Outputs:
%   ID: identificador numerico de los primeros 5 resultados que matchean
%   MATCHES: numero de matches que tuvo cada ID al realizar el query
%
% Nota:
%   Si no encuentra coincidencias, devuelve: ID=0, MATCHES=0
%
% 66.74 Senales y Sistemas, 2do cuat 2015 - FIUBA


% Obtenemos las filas a guardar en la tabla, pasando las caracteristicas de
% binario a decimal. Sumo 1 porque Matlab indexa desde 1
hash = bi2de(huella.') + 1;

% Extraemos los elementos de la tabla que corresponden a los hashes dados
vals = DB.tabla(hash,:);
vals = vals(vals~=0);
if isempty(vals)
    % Si los elementos fueron todos nulos, devuelve cero
    ID = 0; MATCHES = 0; return;
end

% Extraemos de cada elemento el ID numerico y su frame
ID1 = mod(vals,2^DB.ID_nbits);
frames = floor(vals/2^DB.ID_nbits);


% Filtramos por tiempo: para cada ID, se cuenta el numero de coincidencias 
% dentro del intervalo de duracion temporal de la huella (i.e. frame_span)
frame_span = size(huella,2);
ID = unique(ID1);
MATCHES = zeros(size(ID));
for k=1:length(ID)
    frame_aux = frames(ID1==ID(k));
    matches = 0;
    for k2=1:length(frame_aux)
        % match_aux: numero de matches en intervalo frame_span
        match_aux = nnz((frame_aux>=frame_aux(k2)) & (frame_aux<=frame_aux(k2)+frame_span));
        if match_aux>matches
            matches = match_aux;
        end
    end
    MATCHES(k) = matches;
end

% Ordeno ID y MATCHES por orden descendente
[MATCHES,idx] = sort(MATCHES,'descend');
ID = ID(idx);

% Me quedo con los primeros Nmax elementos
Nmax = 5;
N = min([Nmax,size(ID,1)]);
MATCHES = MATCHES(1:N);
ID = ID(1:N);

end

