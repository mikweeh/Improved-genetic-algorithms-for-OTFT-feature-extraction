function [config,data] = OTFT_DataReset(config,data)

% Esta funci�n tiene como objetivo resetear los valores de las variables de
% proceso para que no puedan interferir en la nueva simulaci�n.

% Valor inicial de las variables que hay que buscar en el m�todo
% matem�tico.

config.MM.Vars = [];

% Activaci�n del m�todo directo.

config.On.DM = true;

% Activaci�n del algoritmo gen�tico.

config.On.GA = true;

% Activaci�n del algoritmo de control.

config.On.CF = true;

% Activaci�n del m�todo matem�tico.

config.On.MM = false;


% A partir de este punto, los valores siguientes son variables de proceso y
% no par�metros de configuraci�n.

% Flag indicativo de si se ha pulsado el bot�n de parada.

data.AbortKey = false;

% N�mero de iteraciones del bucle principal.

data.GlobalIter = 0;

% �ltima iteraci�n en la que se registr� una mejora del error.

data.LastImprovementGlobalIter = 0;

% Instante en el que empieza el algoritmo de extracci�n.

data.StartTime = 0;

% Momento en el que se registr� la �ltima mejora del error.

data.LastImprovementTime = 0;

% Error m�nimo conseguido hasta el momento.

data.BestScore= Inf;

% Error m�nimo conseguido antes del actual.

data.LastBestScore = Inf;

% Flag de salida del bucle principal.

data.Exit=false;

% Poblaci�n de individuos (soluciones potenciales).

data.CurrentPop = [];

% Adaptaci�n de la poblaci�n actual (error de cada individuo).

data.PopScore = [];

% �ndice que apunta al individuo mejor adaptado dentro de la poblaci�n
% actual.

data.BestIndivIndex = [];

% Individuo mejor adaptado dentro de la poblaci�n actual (valores).

data.BestIndiv = [];

% Salida de el/los controladores.

data.ControllerOutput = {};

% N�mero de generaci�n actual.

data.Generation = 0;

% Tama�o de la subpoblaci�n actual.

data.SubPopSize = [];

% Subpoblaci�n actual (valores).

data.CurrentSubPop = [];

% Adaptaci�n de la subpoblaci�n actual.

data.SubPopScore = [];

% N�mero de padres necesarios para el tipo de reproducci�n dise�ada.

data.NParents = [];

% Expectativa (probabilidad) de cada individuo de contribuir a la
% generaci�n siguiente.

data.Expectation = [];

% Padres asignados para crear la pr�xima generaci�n (�ndices).

data.Parents = [];

% �ndice de las variables inc�gnitas en el m�todo matem�tico.

data.MM.VarIndex = [];
