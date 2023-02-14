function [config,data] = OTFT_DataReset(config,data)

% Esta función tiene como objetivo resetear los valores de las variables de
% proceso para que no puedan interferir en la nueva simulación.

% Valor inicial de las variables que hay que buscar en el método
% matemático.

config.MM.Vars = [];

% Activación del método directo.

config.On.DM = true;

% Activación del algoritmo genético.

config.On.GA = true;

% Activación del algoritmo de control.

config.On.CF = true;

% Activación del método matemático.

config.On.MM = false;


% A partir de este punto, los valores siguientes son variables de proceso y
% no parámetros de configuración.

% Flag indicativo de si se ha pulsado el botón de parada.

data.AbortKey = false;

% Número de iteraciones del bucle principal.

data.GlobalIter = 0;

% Última iteración en la que se registró una mejora del error.

data.LastImprovementGlobalIter = 0;

% Instante en el que empieza el algoritmo de extracción.

data.StartTime = 0;

% Momento en el que se registró la última mejora del error.

data.LastImprovementTime = 0;

% Error mínimo conseguido hasta el momento.

data.BestScore= Inf;

% Error mínimo conseguido antes del actual.

data.LastBestScore = Inf;

% Flag de salida del bucle principal.

data.Exit=false;

% Población de individuos (soluciones potenciales).

data.CurrentPop = [];

% Adaptación de la población actual (error de cada individuo).

data.PopScore = [];

% Índice que apunta al individuo mejor adaptado dentro de la población
% actual.

data.BestIndivIndex = [];

% Individuo mejor adaptado dentro de la población actual (valores).

data.BestIndiv = [];

% Salida de el/los controladores.

data.ControllerOutput = {};

% Número de generación actual.

data.Generation = 0;

% Tamaño de la subpoblación actual.

data.SubPopSize = [];

% Subpoblación actual (valores).

data.CurrentSubPop = [];

% Adaptación de la subpoblación actual.

data.SubPopScore = [];

% Número de padres necesarios para el tipo de reproducción diseñada.

data.NParents = [];

% Expectativa (probabilidad) de cada individuo de contribuir a la
% generación siguiente.

data.Expectation = [];

% Padres asignados para crear la próxima generación (índices).

data.Parents = [];

% Índice de las variables incógnitas en el método matemático.

data.MM.VarIndex = [];
