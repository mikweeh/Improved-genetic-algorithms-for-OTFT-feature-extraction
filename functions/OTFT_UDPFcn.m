function [str_aux,str1,str2,hObject,handles] = OTFT_UDPFcn(hObject,...
    handles,index,value)

% Esta funci�n tiene como objetivo controlar todo lo referente a la
% modificaci�n de par�metros de configuraci�n del algoritmo por parte del
% usuario.
% Como entradas recibe, adem�s de las variables del entorno gr�fico
% "hObject" y "handles", otras dos variables "index" y "value" que
% contendr�n respectivamente un apuntador al par�metro a modificar y el
% nuevo valor del citado par�metro.
% Las salidas son las variables tipo 'string' que hay que mostrar por
% pantalla.

% Si el valor de entrada no es num�rico, tiene que informarse de un error.

if ~isnumeric(value)
    set(handles.statusbar,'String','Entrada no v�lida.');
    str_aux = get(handles.listconf,'String');
    [str_aux,str1,str2] = deal(str_aux,'','');
    return
end

% Carga de variables

if ~isfield(handles,'T')
    existsT = false;
else
    existsT = true;
    T = handles.T;
end
[config,data] = deal(handles.config,handles.data);

% Asignaci�n de valores actuales

str_sols = {0;...
    config.RCalculate;...
    config.NumMaxGlobalIter;...
    config.LimitError;...
    config.TimeLimit;...
    config.MM.FcnArgs.MaxIter;...
    config.MM.FcnArgs.MaxFunEvals;...
    config.MM.FcnArgs.TolX;...
    config.MM.FcnArgs.TolFun;...
    config.ShowGraph;...
    config.ShowParam};

str_subs = {'Resistencia ds [Ohm] = '; ...
    'Calcular Resistencia ds (1-SI/0-NO) = ';...
    'N�m. max. iteraciones de acercamiento = '; ...
    'Error m�ximo de acercamiento [pu] = '; ...
    'Tiempo m�ximo de acercamiento [s] = '; ...
    'N�m. max. iteraciones de m�todo mat. = '; ...
    'N�m. m�x. de evaluaciones de la funci�n = '; ...
    'Tolerancia de la soluci�n = '; ...
    'Tolerancia de la funci�n = '; ...
    'Gr�fica a cada iteraci�n (1-SI/0-NO) = '; ...
    'Par�metros a cada iteraci�n (1-SI/0-NO) = '};

if existsT
    str_sols{1} = T.R;
end

% Actuaci�n en los diferentes casos

if isempty(index)
    set(handles.statusbar,'String','Cargada configuraci�n por defecto.');
    str1 = '';
    str2 = '';
else
    if isempty(value)
        str_aux = get(handles.listconf,'String');
        [str_aux,str1,str2] = deal(str_aux,'','');
    else
        if index == 1 && ~existsT
            message = sprintf([...
                'No se puede cambiar un par�metro del transistor\n '...
                'hasta que no se hayan cargado los datos de �ste.']);
            set(handles.statusbar,'String',message);
            str_aux = get(handles.listconf,'String');
        else
            switch index
                
                % Valor de la resistencia entre drenador y surtidor.
                
                case 1
                    if value < 0
                        value = 0;
                        message = sprintf([...
                            'La resistencia no puede ser negativa.\n'...
                            'La resistencia inicial ser� de valor %d'],...
                            value);
                        set(handles.statusbar,'String',message);
                        value = 0;
                    else
                        value = round(value);
                        message = sprintf(...
                            'La resistencia inicial ser� de valor %d',...
                            value);
                        set(handles.statusbar,'String',message);
                    end
                    set(handles.improve,'Enable','Off');
                    
                % C�lculo de la resistencia entre drenador y surtidor.
                    
                case 2
                    if value ~= 1
                        message = sprintf(...
                            'No se calcular� el valor de la resistencia.');
                        set(handles.statusbar,'String',message);
                        value = 0;
                    else
                        set(handles.statusbar,'String',...
                            'Se calcular� el valor de la resistencia.');
                    end
                    
                %N�mero m�ximo de iteraciones globales
                    
                case 3
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',[...
                            'Entrada no v�lida. Se fija el n�mero ',...
                            'm�nimo de iteraciones de acercamiento en 1']);
                        value = 1;
                    else
                        message = sprintf([...
                        'Se fija el n�mero de iteraciones de',...
                        ' acercamiento en %d'],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Error l�mite de acercamiento
                    
                case 4 
                    if value < 0
                        set(handles.statusbar,'String',[...
                            'Entrada no v�lida. Se fija el error l�mite'...
                            ,' de acercamiento a su valor por defecto.']);
                        value = 0.01;
                    else
                        message = sprintf(['Se fija el error l�mite ',...
                            'de acercamiento en %1.1e'],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Tiempo l�mite de acercamiento
                    
                case 5 
                    value = round(value);
                    if value < 0
                        set(handles.statusbar,'String',['Entrada no ',...
                            'v�lida. Se fija el tiempo l�mite de ',...
                            'acercamiento a su valor por defecto.']);
                        value = config.TimeLimit;
                    else
                        message = sprintf(['Se fija el error l�mite de',...
                            ' acercamiento en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % N�mero m�ximo de iteraciones del m�todo matem�tico

                case 6 
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',['Entrada no ',...
                            'v�lida. Se fija el n�mero m�ximo de ',...
                            'iteraciones en 1']);
                        value = 1;
                    else
                        message = sprintf(['Se fija el n�mero m�ximo ',...
                            'de iteraciones en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % N�mero m�ximo de evaluaciones de la funci�n en el m�todo
                % matem�tico

                case 7 
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',['Entrada no ',...
                            'v�lida. Se fija el n�mero m�ximo de ',...
                            'evaluaciones en 1']);
                        value = 1;
                    else
                        message = sprintf(['Se fija el n�mero m�ximo ',...
                            'de evaluaciones en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % Tolerancia de la soluci�n.

                case 8 
                    if value < 0
                        value = config.MM.FcnArgs.TolX;
                        message = sprintf(['Entrada no v�lida. Se fija',...
                            ' la tolerancia de la soluci�n en %1.1e'],...
                            value);
                        set(handles.statusbar,'String',message);
                    else
                        message = sprintf(['Se fija la tolerancia de ',...
                            'la soluci�n en %1.1e'],value);
                        set(handles.statusbar,'String',message);
                    end
                
                % Tolerancia de la funci�n.
                    
                case 9 
                    if value < 0
                        value = config.MM.FcnArgs.TolFun;
                        message = sprintf(['Entrada no v�lida. Se fija',...
                            ' la tolerancia de la funci�n en %1.1e '],...
                            value);
                        set(handles.statusbar,'String',message);
                    else
                        message = sprintf(['Se fija la tolerancia de',...
                            ' la funci�n en %1.1e '],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Mostrar gr�fica
                    
                case 10 
                    if value ~= 1
                        set(handles.statusbar,'String',['No se ',...
                            'mostrar�n las gr�fica a cada iteraci�n.']);
                        value = 0;
                    else
                        set(handles.statusbar,'String',['Se mostrar� ',...
                            'la gr�fica a cada iteraci�n.']);
                    end
                    
                % Mostrar par�metros a cada iteraci�n.
                    
                case 11
                    if value ~= 1
                        set(handles.statusbar,'String',['No se ',...
                            'mostrar�n los par�metros a cada iteraci�n.']);
                        value = 0;
                    else
                        set(handles.statusbar,'String',['Se mostrar�n ',...
                            'los par�metros a cada iteraci�n.']);
                    end
            end
            str_sols{index} = value;
        end
    end
end

% Re-asignaci�n de valores

[config.RCalculate,config.NumMaxGlobalIter,config.LimitError,...
    config.TimeLimit,config.MM.FcnArgs.MaxIter,...
    config.MM.FcnArgs.MaxFunEvals,config.MM.FcnArgs.TolX,...
    config.MM.FcnArgs.TolFun,config.ShowGraph,config.ShowParam] = ...
    deal(str_sols{2:end});

if existsT
    T.R = str_sols{1};
end

% Preparaci�n para mostrar por pantalla

for k = 1:size(str_sols,1)
    str_aux{k} = [str_subs{k} num2str(str_sols{k})];
end

if ~isempty(index)
    str1 = str_subs{index};
    str2 = num2str(str_sols{index});
end

% Actualizaci�n de variables

[handles.config,handles.data] = deal(config,data);
if existsT
    handles.T = T;
end

guidata(hObject,handles);
drawnow;
