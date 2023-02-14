function [y,datalog]=saturate(matriz_ent,limites)

% Esta funcion limita los valores de las columnas de la entrada 
% "matriz_ent" a los correspondientes valores mínimo y máximo especificados
% en la fila 1 y fila 2 respectivamente, y en la correspondiente columna de
% la entrada "limites".
% Así pues, dada una "matriz_ent" de 6x4, la entrada "limites" deberá ser 
% de 2x6. Por ejemplo, limites=[0,-10,-5,0,4,6;2,10,10,10,10,8] indica que 
% la salida "y" será una matriz con los mismos valores que "matriz_ent"
% pero el valor máximo de la columna 1 será 2 y el mínimo será 0. En la
% columna 2 el máximo será 10 y el mínimo será -10; en la columna 3 el
% máximo será 10 y el mínimo será -5, etc

% La variable "datalog" será una matriz de las mismas dimensiones que
% "matriz_ent". En cada posición habrá un 1 si se ha realizado una
% saturación debida al valor máximo permitido, un 0 si no se ha realizado
% saturación, y un -1 si se ha realizado una saturación debida al valor
% mínimo

datalog = zeros(size(matriz_ent));
y=matriz_ent;
for k=1:size(limites,2)
    aux = [find(matriz_ent(:,k)>limites(2,k))];
    y(aux,k) = limites(2,k);
    datalog(aux,k) = 1;
    aux = [find(matriz_ent(:,k)<limites(1,k))];
    y(aux,k) = limites(1,k);
    datalog(aux,k) = -1;
end