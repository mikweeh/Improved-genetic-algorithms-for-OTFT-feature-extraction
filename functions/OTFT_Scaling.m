function expectation = OTFT_Scaling

% global config data T;

% Como norma general la funci�n de escalado deber� ofrecer en la variable
% de salida "expectation" una matriz columna con tantos elementos como
% individuos tenga la poblaci�n.
% La posici�n de cada elemento es el �ndice del correspondiente individuo
% de la sub-poblaci�n.
% El valor de cada elemento refleja las expectativas de cada individuo a
% ser elegido como padre de la siguiente generaci�n.
% Sin embargo, en este caso, debido a la configuraci�n del algoritmo usado
% para los OTFT, no resulta necesario llevar a cabo este paso, de manera
% que se gana tiempo si se suprime.

expectation = [];

