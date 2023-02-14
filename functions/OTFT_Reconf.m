function OTFT_Reconf

global config data T;

% Básicamente esta función tiene el objetivo de monitorizar las distintas
% variables del programa con el fin de llevar a cabo alguna variación en la
% configuración del algoritmo si procede.
% En la mayor parte de los algoritmos esta función sólo tendrá que evaluar
% los parámetros de parada; es decir, en base a los datos sobre el
% desarrollo del proceso tendrá que calcularse si ha llegado el momento de
% terminar el algoritmo.

% En el caso del algoritmo empleado para los OTFT, al ser más complejo de
% lo habitual, tienen que evaluarse los parámetros de parada del proceso de
% acercamiento, y también los parámetros de parada del método matemático.

% Cambio del número de individuos élite.

config.GA.NumElite = rem(data.GlobalIter,2);

% Evaluación de parámetros para finalizar el proceso de acercamiento.

if config.On.MM == false
    
    % Se evalúan las condiciones por las cuales debería activarse el método
    % matemático.
    % Son las siguientes:
        % -El error cometido ya es satisfactorio
        % -Se llega el máximo de iteraciones permitidas
        % -Se lleva demasiado tiempo
        % -Se llevan demasiadas iteraciones sin disminuir el error
    
    if (data.BestScore < config.LimitError) ||...
            (data.GlobalIter >= config.NumMaxGlobalIter) ||...
            (cputime - data.StartTime > config.TimeLimit) ||...
            (data.GlobalIter - data.LastImprovementGlobalIter > ...
            config.ImprovementGlobalIterLimit)
        
        % Se activa un método matemático y se desactiva el resto de
        % procesos
        
        config.On.CF = false;
        config.On.GA = false;
        config.On.DM = false;
        config.On.MM = true;
        
        if config.MM.Fcn == 'fminsearch'
            data.MM.VarIndex = [1 2 3 4 5 7];
            config.MM.Vars = data.BestIndiv(1,data.MM.VarIndex);
        end
    end
        
else

    % Cálculo de la resistencia si procede.
    
    if config.RCalculate == 1
        data.MM.VarIndex = [6];
        config.MM.Vars = data.BestIndiv(1,data.MM.VarIndex);
        R = fminbnd(config.FitnessFcn,...
            data.HardRange(1,data.MM.VarIndex),...
            data.HardRange(2,data.MM.VarIndex));
        data.BestIndiv(1,data.MM.VarIndex) = R;
        T.Indiv = data.BestIndiv;
    end
    
    % Flag de salida del proceso
    
    data.Exit = true;
end

% Pulsación de tecla de detener el proceso

if data.AbortKey == true
    data.Exit = true;
    data.MM.VarIndex = [1 2 3 4 5 7];
end