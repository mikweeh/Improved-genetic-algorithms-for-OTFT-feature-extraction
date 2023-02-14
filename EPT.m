%--------------------------------------------------------------------------
% Código de inicialización del entorno gráfico. Generado automáticamente
% por el GUIDE de Matlab.

function varargout = EPT(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EPT_OpeningFcn, ...
                   'gui_OutputFcn',  @EPT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código de inicialización del entorno gráfico.

function EPT_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Name','Extractor de parámetros de transistores.');
guidata(hObject, handles);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Código de parámetros de salida del entorno gráfico. Generado
% automáticamente por el GUIDE de Matlab.

function varargout = EPT_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se pulsa el botón que pone "Carga datos
% transistor".

function cargadat_Callback(hObject, eventdata, handles)

% Se identifica si el usuario ha seleccionado ya el tipo de transistor al
% cual quiere extrerle los parámetros

if ~isfield(handles,'config')
    set(handles.statusbar,'String',...
        'Seleccione primero el tipo de transistor.');
    guidata(hObject,handles);
    return
end

% Se carga el documento con extensión adecuada (".otft" en este caso)

extension = handles.config.Ext;
[filename,pathname]=uigetfile(extension);

% Si en la ventana se pulsa "cancelar" no se carga ningún dato.
if filename == 0
    set(handles.statusbar,'String','No se ha cargado ningún dato');
    return
end

% En caso de que se seleccione un documento, se cargan los datos.

name = cat(2,pathname,filename);
handles.data.Name = name;
if isfield(handles,'T')
    handles = rmfield(handles,'T');
end

dataloader = handles.config.DataLoader;
handles.T = feval(dataloader,name);

% Selección de algunos parámetros del entorno gráfico.

set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
message = sprintf(['Datos del transistor %s cargados'],filename);
set(handles.statusbar,'String',message);
guidata(hObject,handles);
plotfcn = handles.config.PlotFcn;
feval(plotfcn,handles);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function dataconf1_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function dataconf1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se pulsa el botón "Intro".
% La función de este botón es permitir que el usuario cambie la
% configuración por defecto sobre el algoritmo que se va a ejecutar.

function intro_Callback(hObject, eventdata, handles)

% Se identifica el parámetro que el usuario quiere modificar.

if ~isfield(handles,'config')
    return
end

index = get(handles.listconf,'Value');
value = str2num(get(handles.dataconf2,'String'));

if isempty(value)
    value = 'NaN';
end

% Se hace una llamada a la función específica del tipo de transistor actual
% para que se modifique la configuración del proceso de extracción de
% parámetros.

[str_aux,str1,str2,hObject,handles] = ...
    feval(handles.config.UserDefParamFcn,hObject,handles,index,value);

% Se ajustan algunos parámetros del entorno gráfico.

set(handles.listconf,'String',str_aux);
set(handles.listconf,'Value',index);
set(handles.dataconf1,'String',str1);
set(handles.dataconf2,'String',str2);
guidata(hObject,handles);
drawnow
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se cambia la fila seleccionada en la lista
% de configuración de parámetros.
% Este código se utiliza para que cuando el usuario pulse sobre un elemento
% de la lista de configuración, el nombre y valor de éste aparezcan en los
% campos que permiten su modificación.

function listconf_Callback(hObject, eventdata, handles)

index = get(hObject,'Value');
[str_aux,str1,str2,hObject,handles] = ...
    feval(handles.config.UserDefParamFcn,hObject,handles,index,[]);

set(handles.listconf,'String',str_aux);
set(handles.listconf,'Value',index);
set(handles.dataconf1,'String',str1);
set(handles.dataconf2,'String',str2);
drawnow;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function listconf_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function list1_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function list1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function list2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function list2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se pulsa el botón "save". Lo que se hace
% aquí es abrir el documento original que ha servido para cargar los datos
% del transistor, y adjuntarle al final unas líneas que contienen el
% resultado de la extracción de parámetros.

function save_Callback(hObject, eventdata, handles)

to_append = get(handles.list1,'String');
fid = fopen(handles.data.Name,'a');
fprintf(fid,'\r\n');
for k = 1:length(to_append);
    fprintf(fid,[to_append{k} '\r\n']);
end
fclose(fid);
string = ['Se han guardado los datos en el fichero ' handles.data.Name];
set(handles.statusbar,'String',string);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se pulsa el botón "Extraer parámetros".
% Esto es el corazón del programa. En estas líneas se lleva a cabo todo el
% proceso de extracción de parámetros.

function extrac_Callback(hObject, eventdata, handles)

% En primer lugar se evalúa si realmente hay que comenzar con el proceso de
% extracción de parámetros o, por el contrario ha habido un error por parte
% del usuario al pulsar esta tecla.

if ~isfield(handles,'config')
    set(handles.statusbar,'String', ...
        'Seleccione primero el tipo de transistor.');
    return
end

if ~isfield(handles,'T')
    set(handles.statusbar,'String','No hay datos de ningún transistor.');
    return
end

% En todo lo referente al algoritmo de extracción de parámetros se usarán
% estas tres variables globales.

global config data T;

config = handles.config;
data = handles.data;
T = handles.T;

% Es preciso resetear el valor de las variables de proceso que podrían
% haber quedado guardadas con un valor procedente de la extracción
% anterior.

[config,data] = feval(config.DataResetFcn,config,data);

% Desactivación de controles gráficos.

set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
set(handles.intro,'Enable','Off');
set(handles.extrac,'Enable','Off');
set(handles.cargadat,'Enable','Off');
set(handles.popupconf,'Enable','Off');
drawnow;

% Inicialización del proceso de extracción de parámetros

data.StartTime = cputime;
feval(config.InitFcn);
set(handles.statusbar,'String','Calculando.');
drawnow;

% Proceso iterativo

while data.Exit == false

    % Iteraciones
    % Primer paso: Controladores.

    if config.On.CF == true
        feval(config.ControlFcn);
    end

    %Segundo paso: Algoritmo genético.

    if config.On.GA == true

        %Se genera la nueva población

        Single_GA_Step;
    end

    %Tercer paso: Método directo.

    if config.On.DM == true
        feval(config.DMFcn);
    end

    %Cuarto proceso: Método matemático.
    
    if config.On.MM == true
        set(handles.statusbar,'String','Método matemático.');
        drawnow;
        c_error = Math_Method(handles);
    end

    % Evaluación del error.
    
    if config.On.MM == false
        c_error = feval(config.FitnessFcn,[]);
    end
    
    data.BestScore = c_error;
    if data.BestScore < data.LastBestScore
        data.LastBestScore = data.BestScore;
        data.LastImprovementGlobalIter = data.GlobalIter;
        data.LastImprovementTime = cputime;
    end

    % Muestra por pantalla

    [handles.config,handles.data,handles.T] = deal(config,data,T);
    guidata(hObject,handles);
    
    if config.ShowGraph == 1
        feval(config.PlotFcn,handles);
    end
    
    if config.ShowParam == 1
        feval(config.ShowParamFcn,handles);
    end
    
    %Reconfiguración de la próxima iteración.
    
    data.GlobalIter = data.GlobalIter + 1;
    feval(config.ReconfigureFcn);
end

% Actualización de variables.

data.Exit = false;
[handles.config,handles.data,handles.T] = deal(config,data,T);
guidata(hObject,handles);
feval(config.PlotFcn,handles);
feval(config.ShowParamFcn,handles);
drawnow;
clear config data T

% Activación de controles gráficos.

set(handles.improve,'Enable','On');
set(handles.save,'Enable','On');
set(handles.intro,'Enable','On');
set(handles.extrac,'Enable','On');
set(handles.cargadat,'Enable','On');
set(handles.popupconf,'Enable','On');
drawnow;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta al seleccionar el tipo de transitor en el menú
% desplegable.

function popupconf_Callback(hObject, eventdata, handles)

opt = get(handles.popupconf,'Value');
if isfield(handles,'config')
    handles = rmfield(handles,{'config','data'});
    if isfield(handles,'T')
        handles = rmfield(handles,'T');
    end
end

switch opt
    case 1
    case 2
    
    % Opción OTFT, única disponible en esta versión.
    % Se cargan todos los datos necesarios para llevar a cabo el algoritmo
    % que extrae los parámetros de los transistores OTFT. Esto incluye,
    % además de los nombres y valores de las funciones que se usarán, las
    % inicializaciones de los diferentes datos.

    [handles.config, handles.data] = OTFT_Configuration;
        index = [];
        value = [];
        [str_aux,str1,str2,hObject,handles] = ...
            feval(handles.config.UserDefParamFcn,hObject,handles,...
            index,value);
        set(handles.listconf,'String',str_aux);
        set(handles.listconf,'Value',1);
        set(handles.dataconf1,'String',str1);
        set(handles.dataconf2,'String',str2);
end

% Actualización de los controles gráficos.

set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
axes(handles.graf1);
set(handles.graf1,'NextPlot','Replace');
plot([0],[0],'g');
axes(handles.graf2);
set(handles.graf2,'NextPlot','Replace');
plot([0],[0],'g');
drawnow
guidata(hObject,handles);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.

function popupconf_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta cuando se pulsa el botón de "Mejorar resultado".
% Esto lo que hace exactamente es lanzar un método matemático, dando por
% sentado que ya se tiene un punto lo suficientemente cercano a la
% solución.

function improve_Callback(hObject, eventdata, handles)

global config data T;

% Actualización de controles gráficos.

set(handles.statusbar,'String','Calculando');
set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
set(handles.intro,'Enable','Off');
set(handles.extrac,'Enable','Off');
set(handles.cargadat,'Enable','Off');
set(handles.popupconf,'Enable','Off');
set(handles.stop,'Enable','Off');
drawnow;

% Configuración y llamada al método matemático.

[config,data,T] = deal(handles.config,handles.data,handles.T);
config.MM.Vars = data.BestIndiv(1,data.MM.VarIndex);
data.BestScore = Math_Method(handles);

% Actualización de controles gráficos.

set(handles.improve,'Enable','On');
set(handles.save,'Enable','On');
set(handles.intro,'Enable','On');
set(handles.extrac,'Enable','On');
set(handles.cargadat,'Enable','On');
set(handles.popupconf,'Enable','On');
set(handles.stop,'Enable','On');
[handles.config,handles.data,handles.T] = deal(config,data,T);
guidata(hObject,handles);
feval(config.PlotFcn,handles);
feval(config.ShowParamFcn,handles);
drawnow;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Función que lanza el método matemático configurado. Hay tres opciones por
% defecto que coinciden con tres funciones de MAtlab. En caso de no haber
% configurado el algoritmo para ninguna de las tres opciones, se lanzaría
% un método propio que deberá haber desarrollado el programador.

function c_error = Math_Method(handles)

global config data T;

hfunc = config.MM.Fcn;
set(handles.stop,'Enable','Off');
drawnow

% Selección de la opción de método matemático.

switch hfunc;
    
    case 'fminsearch'
        [result,current_error,exit,output] = feval(config.MM.Fcn,...
            config.MM.FitnessFcn,config.MM.Vars,config.MM.FcnArgs,...
            config.MM.FitnessFcnArgs{:});
        data.MM.Output = output;
        data.MM.Exit = exit;

    case 'patternsearch'
        [result,current_error,exit,output] = feval(config.MM.Fcn,...
            {config.MM.FitnessFcn,config.MM.FitnessFcnArgs{:}},...
            config.MM.Vars,[],[],[],[],[],[],config.MM.FcnArgs{:});
        data.MM.Output = output;
        data.MM.Exit = exit;

    case 'fminunc'
        [result,current_error,exit,output] = feval(config.MM.Fcn,...
            config.MM.FitnessFcn,config.MM.Vars,config.MM.FcnArgs{:},...
            config.MM.FitnessFcnArgs{:});
        data.MM.Output = output;
        data.MM.Exit = exit;
        
    otherwise
        [result,current_error,exit,output] = feval(config.MM.Fcn,...
            config.MM.FitnessFcn,config.MM.Vars,config.MM.FcnArgs{:},...
            config.MM.FitnessFcnArgs{:});
        data.MM.Output = output;
        data.MM.Exit = exit;

end

% Evaluación del error.

c_error = feval(config.FitnessFcn,result);
[us,datalog] = saturate(T.Indiv,data.HardRange);

% Mensajes de salida por pantalla.

if any(datalog)
    data.MM.Output.message = sprintf([...
        '\n','Uno o más parámetros están fuera de los rangos que se ',...
        'consideran normales. Se recomienda que repita la simulación.']);
end
set(handles.statusbar,'String',data.MM.Output.message);
set(handles.stop,'Enable','On');
drawnow
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.
function dataconf2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código generado automáticamente por el GUIDE de Matlab.
function dataconf2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Código que se ejecuta al pulsar el botón de "Detener algoritmo".
function stop_Callback(hObject, eventdata, handles)

global data
data.AbortKey = true;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Single_GA_Step

% Esta función lleva a cabo todos los pasos necesarios para generar una
% nueva población a partir de la anterior y de los criterios de
% reproducción.
% Se incluyen las consideraciones sobre migración, escalado, selección,
% generación por cruce y generación por mutación.
% Los resultados se guardan en las variables globales correspondientes.

global config data T;

if ~isfield(data,'Generation')
    data.Generation = 0;
end

% Se realiza una migración si corresponde.

Migration;

% Inicialización de variables.

offset = 0;
totalPop = config.GA.PopSize;

% El bucle que viene a continuación se repetirá para cada sub-polación; es
% decir, para cada elemento del vector "config.GA.PopSize".

for pop = 1:length(totalPop)
    
    % Inicialización de variables de la sub-población actual.
    
    data.SubPopSize =  totalPop(pop);
    ind = 1 + (offset:(offset + data.SubPopSize - 1));
    data.CurrentSubPop = data.CurrentPop(ind,:);
    data.SubPopScore = data.PopScore(ind);

    % Cálculo del número de hijos generados con cada método.
    
    N_Elite_K = config.GA.NumElite;
    N_Cross_K = round(config.GA.CrossFraction*(data.SubPopSize-N_Elite_K));
    N_Mutated_K = data.SubPopSize-N_Elite_K-N_Cross_K;

    % Cálculo del número de padres totales necesarios para cubrir la demada
    % de hijos.
    
    nParents = 2*N_Cross_K + N_Mutated_K;
    data.NParents = nParents;

    % Escalado de expectativas de contribuir a la próxima generación.
    
    data.Expectation = feval(config.GA.ScalingFcn);
    
    % Selección de los padres de la próxima generación. La variable
    % "parents" contiene los índices de los padres de la sub-población
    % actual.

    parents = feval(config.GA.SelectionFcn);
    data.Parents = parents(randperm(length(parents)));

    [us,k] = sort(data.SubPopScore);

    % Creación de los individuos de la próxima generación.
    
    % Individuos élite.
    
    Elite_K  = data.CurrentSubPop(k(1:N_Elite_K),:);

    % Individuos por cruce.
    
    Cross_K = feval(config.GA.CrossoverFcn,data.Parents(1:(2*N_Cross_K)));

    % Individuos por mutación.
    
    Mutated_K = feval(config.GA.MutationFcn,...
        data.Parents((1+2*N_Cross_K):end));
       
    % Agrupación de todos los individuos en la nueva población.
    
    nextPopulation = [ Elite_K ; Cross_K ; Mutated_K ];
    nextPopulation = saturate(nextPopulation,data.HardRange);
    data.CurrentPop(ind,:) = nextPopulation;
    offset = offset + data.SubPopSize;
    
end 

data.Generation = data.Generation + 1;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Migration

% En esta función se lleva a cabo el proceso de migración de individuos
% entre subpoblaciones

global config data T;

if((length(config.GA.PopSize) == 1) ||...
        rem(data.Generation,config.GA.MigrationInterval) ~= 0)
    return
end

populations = config.GA.PopSize;

%Cálculo de índices.

lengths = cumsum(populations);
lengths = lengths(1:(end-1));
starts = [1, 1 + lengths];
ends = starts + populations - 1;
subPops = [starts;ends];

% Número de emigrantes de cada sub-población.

N_Migr = round(populations * config.GA.MigrationFraction);
forward  = min(N_Migr,[N_Migr(2:end),N_Migr(1)]);
backward = forward([end,1:(end-1)]);
indicies = cell(1,length(populations));
newcomers = cell(1,length(populations));

% Identificación de los individuos que migran a otra sub-población.

for pop = 1:length(populations)
    p = subPops(:,pop);

    % Índices de la sub-población.
    
    [us,i] = sort(data.PopScore(p(1):p(2)));
    sourcePop = i(:) + p(1) - 1;
    
    % Destino de los emigrantes.
    
    ahead = 1 + mod(pop,length(populations));  
    newcomers{ahead} = [newcomers{ahead};sourcePop(1:forward(pop))]; 
    
    % Dirección de migración. El número 2 indica que habrá migración hacia
    % delante y hacia atrás. En caso contrario la migración será en una
    % sola dirección.
    
    if config.GA.MigrationDirection == 2
        behind = 1 + mod(pop-2,length(populations));
        newcomers{behind} = [newcomers{behind};sourcePop(1:backward(pop))];
    end
    
    indicies{pop} = sourcePop;
end

% Movimiento de los individuos seleccionados a su correspondiente
% subpoblación.

for i = 1:length(populations)
    from = newcomers{i};
    
    % Individuos reemplazados.
    
    pop = indicies{i};
    n = length(from);
    to = pop((end-n + 1):end);
    
    % Emigración.
    
    data.CurrentPop(to,:) = data.CurrentPop(from,:);
    data.PopScore(to) = data.PopScore(from);
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function [y,datalog] = saturate(matriz_ent,limites)

% Esta funcion limita los valores de las columnas de la entrada 
% "matriz_ent" a los correspondientes valores mínimo y máximo especificados
% en la fila 1 y fila 2 respectivamente, y en la correspondiente columna de
% la entrada "limites".
% Así pues, dada una "matriz_ent" de 6x4, la entrada "limites" deberá ser 
% de 2x6. Por ejemplo, limites=[0,-10,-5,0,4,6;2,10,10,10,10,8] indica que 
% la salida "y" será una matriz con los mismos valores que "matriz_ent"
% pero el valor máximo de la columna 1 será 2 y el mínimo será 0. En la
% columna 2 el máximo será 10 y el mínimo será -10; en la columna 3 el
% máximo será 10 y el mínimo será -5, etc

% La variable "datalog" será una matriz de las mismas dimensiones que
% "matriz_ent". En cada posición habrá un 1 si se ha realizado una
% saturación debida al valor máximo permitido, un 0 si no se ha realizado
% saturación, y un -1 si se ha realizado una saturación debida al valor
% mínimo

datalog = zeros(size(matriz_ent));
y=matriz_ent;
for k=1:size(limites,2)
    aux = [find(matriz_ent(:,k)>limites(2,k))];
    y(aux,k) = limites(2,k);
    datalog(aux,k) = 1;
    aux = [find(matriz_ent(:,k)<limites(1,k))];
    y(aux,k) = limites(1,k);
    datalog(aux,k) = -1;
end
%--------------------------------------------------------------------------