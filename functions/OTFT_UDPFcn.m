function [str_aux,str1,str2,hObject,handles] = OTFT_UDPFcn(hObject,...
    handles,index,value)

% Esta función tiene como objetivo controlar todo lo referente a la
% modificación de parámetros de configuración del algoritmo por parte del
% usuario.
% Como entradas recibe, además de las variables del entorno gráfico
% "hObject" y "handles", otras dos variables "index" y "value" que
% contendrán respectivamente un apuntador al parámetro a modificar y el
% nuevo valor del citado parámetro.
% Las salidas son las variables tipo 'string' que hay que mostrar por
% pantalla.

% Si el valor de entrada no es numérico, tiene que informarse de un error.

if ~isnumeric(value)
    set(handles.statusbar,'String','Entrada no válida.');
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

% Asignación de valores actuales

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
    'Núm. max. iteraciones de acercamiento = '; ...
    'Error máximo de acercamiento [pu] = '; ...
    'Tiempo máximo de acercamiento [s] = '; ...
    'Núm. max. iteraciones de método mat. = '; ...
    'Núm. máx. de evaluaciones de la función = '; ...
    'Tolerancia de la solución = '; ...
    'Tolerancia de la función = '; ...
    'Gráfica a cada iteración (1-SI/0-NO) = '; ...
    'Parámetros a cada iteración (1-SI/0-NO) = '};

if existsT
    str_sols{1} = T.R;
end

% Actuación en los diferentes casos

if isempty(index)
    set(handles.statusbar,'String','Cargada configuración por defecto.');
    str1 = '';
    str2 = '';
else
    if isempty(value)
        str_aux = get(handles.listconf,'String');
        [str_aux,str1,str2] = deal(str_aux,'','');
    else
        if index == 1 && ~existsT
            message = sprintf([...
                'No se puede cambiar un parámetro del transistor\n '...
                'hasta que no se hayan cargado los datos de éste.']);
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
                            'La resistencia inicial será de valor %d'],...
                            value);
                        set(handles.statusbar,'String',message);
                        value = 0;
                    else
                        value = round(value);
                        message = sprintf(...
                            'La resistencia inicial será de valor %d',...
                            value);
                        set(handles.statusbar,'String',message);
                    end
                    set(handles.improve,'Enable','Off');
                    
                % Cálculo de la resistencia entre drenador y surtidor.
                    
                case 2
                    if value ~= 1
                        message = sprintf(...
                            'No se calculará el valor de la resistencia.');
                        set(handles.statusbar,'String',message);
                        value = 0;
                    else
                        set(handles.statusbar,'String',...
                            'Se calculará el valor de la resistencia.');
                    end
                    
                %Número máximo de iteraciones globales
                    
                case 3
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',[...
                            'Entrada no válida. Se fija el número ',...
                            'mínimo de iteraciones de acercamiento en 1']);
                        value = 1;
                    else
                        message = sprintf([...
                        'Se fija el número de iteraciones de',...
                        ' acercamiento en %d'],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Error límite de acercamiento
                    
                case 4 
                    if value < 0
                        set(handles.statusbar,'String',[...
                            'Entrada no válida. Se fija el error límite'...
                            ,' de acercamiento a su valor por defecto.']);
                        value = 0.01;
                    else
                        message = sprintf(['Se fija el error límite ',...
                            'de acercamiento en %1.1e'],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Tiempo límite de acercamiento
                    
                case 5 
                    value = round(value);
                    if value < 0
                        set(handles.statusbar,'String',['Entrada no ',...
                            'válida. Se fija el tiempo límite de ',...
                            'acercamiento a su valor por defecto.']);
                        value = config.TimeLimit;
                    else
                        message = sprintf(['Se fija el error límite de',...
                            ' acercamiento en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % Número máximo de iteraciones del método matemático

                case 6 
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',['Entrada no ',...
                            'válida. Se fija el número máximo de ',...
                            'iteraciones en 1']);
                        value = 1;
                    else
                        message = sprintf(['Se fija el número máximo ',...
                            'de iteraciones en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % Número máximo de evaluaciones de la función en el método
                % matemático

                case 7 
                    value = round(value);
                    if value < 1
                        set(handles.statusbar,'String',['Entrada no ',...
                            'válida. Se fija el número máximo de ',...
                            'evaluaciones en 1']);
                        value = 1;
                    else
                        message = sprintf(['Se fija el número máximo ',...
                            'de evaluaciones en %d'],value);
                        set(handles.statusbar,'String',message);
                    end

                % Tolerancia de la solución.

                case 8 
                    if value < 0
                        value = config.MM.FcnArgs.TolX;
                        message = sprintf(['Entrada no válida. Se fija',...
                            ' la tolerancia de la solución en %1.1e'],...
                            value);
                        set(handles.statusbar,'String',message);
                    else
                        message = sprintf(['Se fija la tolerancia de ',...
                            'la solución en %1.1e'],value);
                        set(handles.statusbar,'String',message);
                    end
                
                % Tolerancia de la función.
                    
                case 9 
                    if value < 0
                        value = config.MM.FcnArgs.TolFun;
                        message = sprintf(['Entrada no válida. Se fija',...
                            ' la tolerancia de la función en %1.1e '],...
                            value);
                        set(handles.statusbar,'String',message);
                    else
                        message = sprintf(['Se fija la tolerancia de',...
                            ' la función en %1.1e '],value);
                        set(handles.statusbar,'String',message);
                    end
                    
                % Mostrar gráfica
                    
                case 10 
                    if value ~= 1
                        set(handles.statusbar,'String',['No se ',...
                            'mostrarán las gráfica a cada iteración.']);
                        value = 0;
                    else
                        set(handles.statusbar,'String',['Se mostrará ',...
                            'la gráfica a cada iteración.']);
                    end
                    
                % Mostrar parámetros a cada iteración.
                    
                case 11
                    if value ~= 1
                        set(handles.statusbar,'String',['No se ',...
                            'mostrarán los parámetros a cada iteración.']);
                        value = 0;
                    else
                        set(handles.statusbar,'String',['Se mostrarán ',...
                            'los parámetros a cada iteración.']);
                    end
            end
            str_sols{index} = value;
        end
    end
end

% Re-asignación de valores

[config.RCalculate,config.NumMaxGlobalIter,config.LimitError,...
    config.TimeLimit,config.MM.FcnArgs.MaxIter,...
    config.MM.FcnArgs.MaxFunEvals,config.MM.FcnArgs.TolX,...
    config.MM.FcnArgs.TolFun,config.ShowGraph,config.ShowParam] = ...
    deal(str_sols{2:end});

if existsT
    T.R = str_sols{1};
end

% Preparación para mostrar por pantalla

for k = 1:size(str_sols,1)
    str_aux{k} = [str_subs{k} num2str(str_sols{k})];
end

if ~isempty(index)
    str1 = str_subs{index};
    str2 = num2str(str_sols{index});
end

% Actualización de variables

[handles.config,handles.data] = deal(config,data);
if existsT
    handles.T = T;
end

guidata(hObject,handles);
drawnow;
