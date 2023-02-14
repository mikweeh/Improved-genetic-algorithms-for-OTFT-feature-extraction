function OTFT_Reconf

global config data T;

% B�sicamente esta funci�n tiene el objetivo de monitorizar las distintas
% variables del programa con el fin de llevar a cabo alguna variaci�n en la
% configuraci�n del algoritmo si procede.
% En la mayor parte de los algoritmos esta funci�n s�lo tendr� que evaluar
% los par�metros de parada; es decir, en base a los datos sobre el
% desarrollo del proceso tendr� que calcularse si ha llegado el momento de
% terminar el algoritmo.

% En el caso del algoritmo empleado para los OTFT, al ser m�s complejo de
% lo habitual, tienen que evaluarse los par�metros de parada del proceso de
% acercamiento, y tambi�n los par�metros de parada del m�todo matem�tico.

% Cambio del n�mero de individuos �lite.

config.GA.NumElite = rem(data.GlobalIter,2);

% Evaluaci�n de par�metros para finalizar el proceso de acercamiento.

if config.On.MM == false
    
    % Se eval�an las condiciones por las cuales deber�a activarse el m�todo
    % matem�tico.
    % Son las siguientes:
        % -El error cometido ya es satisfactorio
        % -Se llega el m�ximo de iteraciones permitidas
        % -Se lleva demasiado tiempo
        % -Se llevan demasiadas iteraciones sin disminuir el error
    
    if (data.BestScore < config.LimitError) ||...
            (data.GlobalIter >= config.NumMaxGlobalIter) ||...
            (cputime - data.StartTime > config.TimeLimit) ||...
            (data.GlobalIter - data.LastImprovementGlobalIter > ...
            config.ImprovementGlobalIterLimit)
        
        % Se activa un m�todo matem�tico y se desactiva el resto de
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

    % C�lculo de la resistencia si procede.
    
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

% Pulsaci�n de tecla de detener el proceso

if data.AbortKey == true
    data.Exit = true;
    data.MM.VarIndex = [1 2 3 4 5 7];
end