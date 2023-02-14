function parents = OTFT_Selection

% global config data T;

% Como norma general una función de selección ofrecerá como resultado una
% matriz fila con los valores de los índices que apuntan a los padres
% seleccionados en la sub-población actual.
% Sin embargo, en este caso, debido a la configuración del algoritmo usado
% para los OTFT, no resulta necesario implementar este proceso y se gana
% tiempo si se suprime.

parents = [];
