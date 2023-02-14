function [config,data] = OTFT_Configuration

% Esta función tiene como cometido configurar las variables del programa de
% tal forma que se pueda llevar a cabo el algoritmo de búsqueda
% seleccionado.

% En este caso se configura el algoritmo propio para la extracción de
% parámetros de transistores orgánicos de película delgada (OTFT).

% Los argumentos de salida de esta función son las variables "config" y
% "data".

% "config" tiene datos de la configuración de todo el proceso; es decir, de
% todos los pasos del algoritmo.
% "data" contiene datos del estado de los cálculos y de parámetros de los
% algoritmos necesarios para poder seguirlos.

% Configuración de semilla aleatoria para ser usada en el algoritmo
% genético.

rand('state',sum(100*clock));
randn('state',sum(100*clock));
rand('state',0);
randn('state',0);

% Variable config.

% Cargador de datos de transistores OTFT.

config.DataLoader = @OTFT_DataLoader;

% Función de reseteado de datos para empezar el algoritmo.

config.DataResetFcn = @OTFT_DataReset;

% Extensión de los documentos que contienen datos de transistores OTFT.

config.Ext = '*.otft';

% Función que contiene lo que se quiere mostrar en las gráficas. En este
% caso la corriente entre drenador y surtidor.

config.PlotFcn = @OTFT_IdsPlotter;

% Función de inicialización del algoritmo. Se genera la población inicial.

config.InitFcn = @OTFT_Init;

% Función de ajuste. Es la función que calcula el error entre la solución
% aportada por el algoritmo y las medidas realizadas. Es por tanto el
% objetivo a minimizar.

config.FitnessFcn = @OTFT_Fitness;

% Función de método directo de extracción de parámetros. En este caso sólo
% servirá para el cálculo de Vaa.

config.DMFcn = @OTFT_Direct;

% Función que implementa el control realizado mediante controladores. En
% este caso se usan controladores proporcionales.

config.ControlFcn = @OTFT_Control;

% Función de parámetros configurables por el usuario, tales como el número
% máximo de iteraciones, el error máximo admisible antes del método
% matemático, etc.

config.UserDefParamFcn = @OTFT_UDPFcn;

% Función de actualización de los parámetros que hay que mostrar al
% usuario.

config.ShowParamFcn =@OTFT_ShowParamFcn;

% Flag indicativo de si hay que calcular el parámetro R.

config.RCalculate = 0;

% Flag indicativo de si hay que mostrar las gráficas a cada iteración (1
% Activado, 0 Desactivado).

config.ShowGraph = 1;

% Flag indicativo de si hay que mostrar los resultados de la simulación a
% cada iteración (1 activado, 0 desactivado)

config.ShowParam = 1;

% Función de reconfiguración de la siguiente iteración en el proceso
% general de extracción de parámetros.

config.ReconfigureFcn = @OTFT_Reconf;

% Número máximo de iteraciones del proceso general.

config.NumMaxGlobalIter = 100;

%Error máximo que se debe alcanzar para poder pasar al método matemático.

config.LimitError = 0.005;

% Número máximo de iteraciones sin reducir el error.

config.ImprovementGlobalIterLimit = 20;

% Tiempo límite del algoritmo en segundos.

config.TimeLimit = 120;

% Tiempo máximo sin que se mejore el resultado (en segundos).

config.ImprovementTimeLimit = 60;


% Parámetros del algoritmo genético.
% Intervalo de migración.

config.GA.MigrationInterval = 1000;

% Fracción sobre el total de cada subpoblación de individuos que migrarán.

config.GA.MigrationFraction = 0;

% Sentido de migración. 1--> Un sentido, 2--> Ambos sentidos.

config.GA.MigrationDirection = 1; 

% Número de individuos que pasan sin mutación a la siguiente generación.

config.GA.NumElite = 0;

% Función de reproducción por cruce de individuos.

config.GA.CrossoverFcn = @OTFT_Crossover;

% Fracción de individuos que se generarán por cruce.

config.GA.CrossFraction = 0;

% Función de escalado.

config.GA.ScalingFcn = @OTFT_Scaling;

% Función de selección.

config.GA.SelectionFcn = @OTFT_Selection;

% Función de mutación.

config.GA.MutationFcn = @OTFT_Mutation;

% Número de incógnitas o variables de la función.

config.GA.NumVars = 8;

% Tamaño de la población. Este dato puede darse en forma de vector si se
% quieren tener varias subpoblaciones.

config.GA.PopSize = [100];

% Parámetros del método matemático.
% Función utilizada para buscar el mínimo,

config.MM.Fcn = 'fminsearch';

% Argumentos del método matemático utilizado.
% Activación/desactivación de salida por pantalla.

config.MM.FcnArgs.Display = 'off';

% Número máximo de evaluaciones de la función.

config.MM.FcnArgs.MaxFunEvals = 1200;

% Número máximo de iteraciones.

config.MM.FcnArgs.MaxIter = 1200;

% Tolerancia de la función.

config.MM.FcnArgs.TolFun = 1e-8;

% Tolerancia de la solución.

config.MM.FcnArgs.TolX = 1e-5;

% Función de ajuste del método matemático.

config.MM.FitnessFcn = @OTFT_Fitness_2;

% Argumentos de la función de ajuste del método matemático.

config.MM.FitnessFcnArgs = {};

% Configuración de otros datos de interés para la correcta ejecución del
% algoritmo.
% Rango de valores entre los cuales deberían estar las soluciones
% encontradas. En algunos casos superar estos límites es físicamente
% imposible; en otros, aunque es físicamente posible, se trataría de una
% solución muy extraña.

data.HardRange= [ -30, -1, 0.05,    0.1, -0.01,    0, 0,    0;...
                   30,  5,    4, 100000,  0.01, 10e6, 7, 1e-6];
              
% Nombre completo (incluyendo todo el path) del documento que contiene los
% datos del transistor a analizar.

data.Name = '';

% Parámetros del método directo necesarios para el cálculo de Vaa.
% Intensidad medida en el punto de operación.

data.DM.IMeasOp = 1e-6;

% Tensión Vds medida en el punto de operación.

data.DM.VdsOp = 0;

% Tensión Vgs medida en el punto de operación.

data.DM.VgsOp = 0;


% El resto de parámetros del algoritmo se configuran en la siguiente
% función.

[config,data] = OTFT_DataReset(config,data);