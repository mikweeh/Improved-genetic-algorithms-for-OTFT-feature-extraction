function [config,data] = OTFT_Configuration

% Esta funci�n tiene como cometido configurar las variables del programa de
% tal forma que se pueda llevar a cabo el algoritmo de b�squeda
% seleccionado.

% En este caso se configura el algoritmo propio para la extracci�n de
% par�metros de transistores org�nicos de pel�cula delgada (OTFT).

% Los argumentos de salida de esta funci�n son las variables "config" y
% "data".

% "config" tiene datos de la configuraci�n de todo el proceso; es decir, de
% todos los pasos del algoritmo.
% "data" contiene datos del estado de los c�lculos y de par�metros de los
% algoritmos necesarios para poder seguirlos.

% Configuraci�n de semilla aleatoria para ser usada en el algoritmo
% gen�tico.

rand('state',sum(100*clock));
randn('state',sum(100*clock));
rand('state',0);
randn('state',0);

% Variable config.

% Cargador de datos de transistores OTFT.

config.DataLoader = @OTFT_DataLoader;

% Funci�n de reseteado de datos para empezar el algoritmo.

config.DataResetFcn = @OTFT_DataReset;

% Extensi�n de los documentos que contienen datos de transistores OTFT.

config.Ext = '*.otft';

% Funci�n que contiene lo que se quiere mostrar en las gr�ficas. En este
% caso la corriente entre drenador y surtidor.

config.PlotFcn = @OTFT_IdsPlotter;

% Funci�n de inicializaci�n del algoritmo. Se genera la poblaci�n inicial.

config.InitFcn = @OTFT_Init;

% Funci�n de ajuste. Es la funci�n que calcula el error entre la soluci�n
% aportada por el algoritmo y las medidas realizadas. Es por tanto el
% objetivo a minimizar.

config.FitnessFcn = @OTFT_Fitness;

% Funci�n de m�todo directo de extracci�n de par�metros. En este caso s�lo
% servir� para el c�lculo de Vaa.

config.DMFcn = @OTFT_Direct;

% Funci�n que implementa el control realizado mediante controladores. En
% este caso se usan controladores proporcionales.

config.ControlFcn = @OTFT_Control;

% Funci�n de par�metros configurables por el usuario, tales como el n�mero
% m�ximo de iteraciones, el error m�ximo admisible antes del m�todo
% matem�tico, etc.

config.UserDefParamFcn = @OTFT_UDPFcn;

% Funci�n de actualizaci�n de los par�metros que hay que mostrar al
% usuario.

config.ShowParamFcn =@OTFT_ShowParamFcn;

% Flag indicativo de si hay que calcular el par�metro R.

config.RCalculate = 0;

% Flag indicativo de si hay que mostrar las gr�ficas a cada iteraci�n (1
% Activado, 0 Desactivado).

config.ShowGraph = 1;

% Flag indicativo de si hay que mostrar los resultados de la simulaci�n a
% cada iteraci�n (1 activado, 0 desactivado)

config.ShowParam = 1;

% Funci�n de reconfiguraci�n de la siguiente iteraci�n en el proceso
% general de extracci�n de par�metros.

config.ReconfigureFcn = @OTFT_Reconf;

% N�mero m�ximo de iteraciones del proceso general.

config.NumMaxGlobalIter = 100;

%Error m�ximo que se debe alcanzar para poder pasar al m�todo matem�tico.

config.LimitError = 0.005;

% N�mero m�ximo de iteraciones sin reducir el error.

config.ImprovementGlobalIterLimit = 20;

% Tiempo l�mite del algoritmo en segundos.

config.TimeLimit = 120;

% Tiempo m�ximo sin que se mejore el resultado (en segundos).

config.ImprovementTimeLimit = 60;


% Par�metros del algoritmo gen�tico.
% Intervalo de migraci�n.

config.GA.MigrationInterval = 1000;

% Fracci�n sobre el total de cada subpoblaci�n de individuos que migrar�n.

config.GA.MigrationFraction = 0;

% Sentido de migraci�n. 1--> Un sentido, 2--> Ambos sentidos.

config.GA.MigrationDirection = 1; 

% N�mero de individuos que pasan sin mutaci�n a la siguiente generaci�n.

config.GA.NumElite = 0;

% Funci�n de reproducci�n por cruce de individuos.

config.GA.CrossoverFcn = @OTFT_Crossover;

% Fracci�n de individuos que se generar�n por cruce.

config.GA.CrossFraction = 0;

% Funci�n de escalado.

config.GA.ScalingFcn = @OTFT_Scaling;

% Funci�n de selecci�n.

config.GA.SelectionFcn = @OTFT_Selection;

% Funci�n de mutaci�n.

config.GA.MutationFcn = @OTFT_Mutation;

% N�mero de inc�gnitas o variables de la funci�n.

config.GA.NumVars = 8;

% Tama�o de la poblaci�n. Este dato puede darse en forma de vector si se
% quieren tener varias subpoblaciones.

config.GA.PopSize = [100];

% Par�metros del m�todo matem�tico.
% Funci�n utilizada para buscar el m�nimo,

config.MM.Fcn = 'fminsearch';

% Argumentos del m�todo matem�tico utilizado.
% Activaci�n/desactivaci�n de salida por pantalla.

config.MM.FcnArgs.Display = 'off';

% N�mero m�ximo de evaluaciones de la funci�n.

config.MM.FcnArgs.MaxFunEvals = 1200;

% N�mero m�ximo de iteraciones.

config.MM.FcnArgs.MaxIter = 1200;

% Tolerancia de la funci�n.

config.MM.FcnArgs.TolFun = 1e-8;

% Tolerancia de la soluci�n.

config.MM.FcnArgs.TolX = 1e-5;

% Funci�n de ajuste del m�todo matem�tico.

config.MM.FitnessFcn = @OTFT_Fitness_2;

% Argumentos de la funci�n de ajuste del m�todo matem�tico.

config.MM.FitnessFcnArgs = {};

% Configuraci�n de otros datos de inter�s para la correcta ejecuci�n del
% algoritmo.
% Rango de valores entre los cuales deber�an estar las soluciones
% encontradas. En algunos casos superar estos l�mites es f�sicamente
% imposible; en otros, aunque es f�sicamente posible, se tratar�a de una
% soluci�n muy extra�a.

data.HardRange= [ -30, -1, 0.05,    0.1, -0.01,    0, 0,    0;...
                   30,  5,    4, 100000,  0.01, 10e6, 7, 1e-6];
              
% Nombre completo (incluyendo todo el path) del documento que contiene los
% datos del transistor a analizar.

data.Name = '';

% Par�metros del m�todo directo necesarios para el c�lculo de Vaa.
% Intensidad medida en el punto de operaci�n.

data.DM.IMeasOp = 1e-6;

% Tensi�n Vds medida en el punto de operaci�n.

data.DM.VdsOp = 0;

% Tensi�n Vgs medida en el punto de operaci�n.

data.DM.VgsOp = 0;


% El resto de par�metros del algoritmo se configuran en la siguiente
% funci�n.

[config,data] = OTFT_DataReset(config,data);