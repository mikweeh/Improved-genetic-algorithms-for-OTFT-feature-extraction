function expectation = OTFT_Scaling

% global config data T;

% Como norma general la función de escalado deberá ofrecer en la variable
% de salida "expectation" una matriz columna con tantos elementos como
% individuos tenga la población.
% La posición de cada elemento es el índice del correspondiente individuo
% de la sub-población.
% El valor de cada elemento refleja las expectativas de cada individuo a
% ser elegido como padre de la siguiente generación.
% Sin embargo, en este caso, debido a la configuración del algoritmo usado
% para los OTFT, no resulta necesario llevar a cabo este paso, de manera
% que se gana tiempo si se suprime.

expectation = [];

