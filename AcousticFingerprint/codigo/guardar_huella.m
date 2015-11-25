function DB = guardar_huella(ID,huella,DB)
%DB = guardar_huella(ID,HUELLA,DB)
% 
% Guarda la huella digital acustica HUELLA en la tabla hash de la estructura
% DB, identificando la cancion con el identificador numerico ID.
%
% Inputs:
%   ID: identificador numerico del tema que corresponde a la huella
%   HUELLA: huella acustica en forma de matriz binaria (unos y ceros)
%   DB: estructura con los siguientes campos
%       - hash_nbits: numero de bits para el hash
%       - n_entries: numero de columnas de la tabla
%       - ID_nbits: numero de bits para guardar ID numerico de la cancion
%       - tabla: tabla hash de 2^hash_nbits filas x n_entries columnas
%
% Outputs:
%   DB: estructura con tabla hash actualizada
%
% 66.74 Senales y Sistemas, 2do cuat 2015 - FIUBA

pkg load communications

% Verificamos que HUELLA sea una matriz binaria
if any(huella(:)~=0 & huella(:)~=1)
    error('La matriz HUELLA contiene elementos no binarios')
end

% Verificamos que HUELLA tenga hash_nbits filas
if size(huella,1) ~= DB.hash_nbits
    error('La matriz HUELLA tiene %d filas en lugar de %d',size(huella,1),DB.hash_nbits)
end

% Verificamos que ID sea un entero mayor o igual a 1
if ID<1 || ~isinteger(ID)
    error('El identificador ID debe ser un entero mayor o igual a 1')
end

% Generamos el elemento VAL a guardar, concatenando los bits del ID con los
% bits del tiempo de cada frame
frames_nbits = 32-DB.ID_nbits;
frames = mod(1:size(huella,2),2^frames_nbits);
val = uint32(ID + 2^DB.ID_nbits*frames);

% Obtenemos las filas a guardar en la tabla, pasando las caracteristicas de
% binario a decimal. Sumo 1 porque Matlab indexa desde 1
hash = bi2de(huella.') + 1;

% Primero grabamos en las filas en que queda espacio
fila_ok = DB.tabla(hash,end)==0;  % Filas que tienen espacio al final
hash_ok = hash(fila_ok);
DB.tabla(hash_ok+size(DB.tabla,1)*(sum(DB.tabla(hash_ok,:)~=0,2)+1)) = val(fila_ok);

% Finalmente grabamos en las filas que estan llenas, pisando algun
% valor anterior al azar (colision)
hash_col = hash(~fila_ok);
idx_rand = ceil(rand*DB.n_entries);
DB.tabla(hash_col,idx_rand) = val(~fila_ok);


end