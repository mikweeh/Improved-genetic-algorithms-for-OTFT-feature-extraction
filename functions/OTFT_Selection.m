function parents = OTFT_Selection

% global config data T;

% Como norma general una funci�n de selecci�n ofrecer� como resultado una
% matriz fila con los valores de los �ndices que apuntan a los padres
% seleccionados en la sub-poblaci�n actual.
% Sin embargo, en este caso, debido a la configuraci�n del algoritmo usado
% para los OTFT, no resulta necesario implementar este proceso y se gana
% tiempo si se suprime.

parents = [];
