%--------------------------------------------------------------------------
% C�digo de inicializaci�n del entorno gr�fico. Generado autom�ticamente
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
% C�digo de inicializaci�n del entorno gr�fico.

function EPT_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Name','Extractor de par�metros de transistores.');
guidata(hObject, handles);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% C�digo de par�metros de salida del entorno gr�fico. Generado
% autom�ticamente por el GUIDE de Matlab.

function varargout = EPT_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta cuando se pulsa el bot�n que pone "Carga datos
% transistor".

function cargadat_Callback(hObject, eventdata, handles)

% Se identifica si el usuario ha seleccionado ya el tipo de transistor al
% cual quiere extrerle los par�metros

if ~isfield(handles,'config')
    set(handles.statusbar,'String',...
        'Seleccione primero el tipo de transistor.');
    guidata(hObject,handles);
    return
end

% Se carga el documento con extensi�n adecuada (".otft" en este caso)

extension = handles.config.Ext;
[filename,pathname]=uigetfile(extension);

% Si en la ventana se pulsa "cancelar" no se carga ning�n dato.
if filename == 0
    set(handles.statusbar,'String','No se ha cargado ning�n dato');
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

% Selecci�n de algunos par�metros del entorno gr�fico.

set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
message = sprintf(['Datos del transistor %s cargados'],filename);
set(handles.statusbar,'String',message);
guidata(hObject,handles);
plotfcn = handles.config.PlotFcn;
feval(plotfcn,handles);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function dataconf1_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function dataconf1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta cuando se pulsa el bot�n "Intro".
% La funci�n de este bot�n es permitir que el usuario cambie la
% configuraci�n por defecto sobre el algoritmo que se va a ejecutar.

function intro_Callback(hObject, eventdata, handles)

% Se identifica el par�metro que el usuario quiere modificar.

if ~isfield(handles,'config')
    return
end

index = get(handles.listconf,'Value');
value = str2num(get(handles.dataconf2,'String'));

if isempty(value)
    value = 'NaN';
end

% Se hace una llamada a la funci�n espec�fica del tipo de transistor actual
% para que se modifique la configuraci�n del proceso de extracci�n de
% par�metros.

[str_aux,str1,str2,hObject,handles] = ...
    feval(handles.config.UserDefParamFcn,hObject,handles,index,value);

% Se ajustan algunos par�metros del entorno gr�fico.

set(handles.listconf,'String',str_aux);
set(handles.listconf,'Value',index);
set(handles.dataconf1,'String',str1);
set(handles.dataconf2,'String',str2);
guidata(hObject,handles);
drawnow
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta cuando se cambia la fila seleccionada en la lista
% de configuraci�n de par�metros.
% Este c�digo se utiliza para que cuando el usuario pulse sobre un elemento
% de la lista de configuraci�n, el nombre y valor de �ste aparezcan en los
% campos que permiten su modificaci�n.

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
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function listconf_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function list1_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function list1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function list2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function list2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta cuando se pulsa el bot�n "save". Lo que se hace
% aqu� es abrir el documento original que ha servido para cargar los datos
% del transistor, y adjuntarle al final unas l�neas que contienen el
% resultado de la extracci�n de par�metros.

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
% C�digo que se ejecuta cuando se pulsa el bot�n "Extraer par�metros".
% Esto es el coraz�n del programa. En estas l�neas se lleva a cabo todo el
% proceso de extracci�n de par�metros.

function extrac_Callback(hObject, eventdata, handles)

% En primer lugar se eval�a si realmente hay que comenzar con el proceso de
% extracci�n de par�metros o, por el contrario ha habido un error por parte
% del usuario al pulsar esta tecla.

if ~isfield(handles,'config')
    set(handles.statusbar,'String', ...
        'Seleccione primero el tipo de transistor.');
    return
end

if ~isfield(handles,'T')
    set(handles.statusbar,'String','No hay datos de ning�n transistor.');
    return
end

% En todo lo referente al algoritmo de extracci�n de par�metros se usar�n
% estas tres variables globales.

global config data T;

config = handles.config;
data = handles.data;
T = handles.T;

% Es preciso resetear el valor de las variables de proceso que podr�an
% haber quedado guardadas con un valor procedente de la extracci�n
% anterior.

[config,data] = feval(config.DataResetFcn,config,data);

% Desactivaci�n de controles gr�ficos.

set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
set(handles.intro,'Enable','Off');
set(handles.extrac,'Enable','Off');
set(handles.cargadat,'Enable','Off');
set(handles.popupconf,'Enable','Off');
drawnow;

% Inicializaci�n del proceso de extracci�n de par�metros

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

    %Segundo paso: Algoritmo gen�tico.

    if config.On.GA == true

        %Se genera la nueva poblaci�n

        Single_GA_Step;
    end

    %Tercer paso: M�todo directo.

    if config.On.DM == true
        feval(config.DMFcn);
    end

    %Cuarto proceso: M�todo matem�tico.
    
    if config.On.MM == true
        set(handles.statusbar,'String','M�todo matem�tico.');
        drawnow;
        c_error = Math_Method(handles);
    end

    % Evaluaci�n del error.
    
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
    
    %Reconfiguraci�n de la pr�xima iteraci�n.
    
    data.GlobalIter = data.GlobalIter + 1;
    feval(config.ReconfigureFcn);
end

% Actualizaci�n de variables.

data.Exit = false;
[handles.config,handles.data,handles.T] = deal(config,data,T);
guidata(hObject,handles);
feval(config.PlotFcn,handles);
feval(config.ShowParamFcn,handles);
drawnow;
clear config data T

% Activaci�n de controles gr�ficos.

set(handles.improve,'Enable','On');
set(handles.save,'Enable','On');
set(handles.intro,'Enable','On');
set(handles.extrac,'Enable','On');
set(handles.cargadat,'Enable','On');
set(handles.popupconf,'Enable','On');
drawnow;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta al seleccionar el tipo de transitor en el men�
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
    
    % Opci�n OTFT, �nica disponible en esta versi�n.
    % Se cargan todos los datos necesarios para llevar a cabo el algoritmo
    % que extrae los par�metros de los transistores OTFT. Esto incluye,
    % adem�s de los nombres y valores de las funciones que se usar�n, las
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

% Actualizaci�n de los controles gr�ficos.

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
% C�digo generado autom�ticamente por el GUIDE de Matlab.

function popupconf_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta cuando se pulsa el bot�n de "Mejorar resultado".
% Esto lo que hace exactamente es lanzar un m�todo matem�tico, dando por
% sentado que ya se tiene un punto lo suficientemente cercano a la
% soluci�n.

function improve_Callback(hObject, eventdata, handles)

global config data T;

% Actualizaci�n de controles gr�ficos.

set(handles.statusbar,'String','Calculando');
set(handles.improve,'Enable','Off');
set(handles.save,'Enable','Off');
set(handles.intro,'Enable','Off');
set(handles.extrac,'Enable','Off');
set(handles.cargadat,'Enable','Off');
set(handles.popupconf,'Enable','Off');
set(handles.stop,'Enable','Off');
drawnow;

% Configuraci�n y llamada al m�todo matem�tico.

[config,data,T] = deal(handles.config,handles.data,handles.T);
config.MM.Vars = data.BestIndiv(1,data.MM.VarIndex);
data.BestScore = Math_Method(handles);

% Actualizaci�n de controles gr�ficos.

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
% Funci�n que lanza el m�todo matem�tico configurado. Hay tres opciones por
% defecto que coinciden con tres funciones de MAtlab. En caso de no haber
% configurado el algoritmo para ninguna de las tres opciones, se lanzar�a
% un m�todo propio que deber� haber desarrollado el programador.

function c_error = Math_Method(handles)

global config data T;

hfunc = config.MM.Fcn;
set(handles.stop,'Enable','Off');
drawnow

% Selecci�n de la opci�n de m�todo matem�tico.

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

% Evaluaci�n del error.

c_error = feval(config.FitnessFcn,result);
[us,datalog] = saturate(T.Indiv,data.HardRange);

% Mensajes de salida por pantalla.

if any(datalog)
    data.MM.Output.message = sprintf([...
        '\n','Uno o m�s par�metros est�n fuera de los rangos que se ',...
        'consideran normales. Se recomienda que repita la simulaci�n.']);
end
set(handles.statusbar,'String',data.MM.Output.message);
set(handles.stop,'Enable','On');
drawnow
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.
function dataconf2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo generado autom�ticamente por el GUIDE de Matlab.
function dataconf2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% C�digo que se ejecuta al pulsar el bot�n de "Detener algoritmo".
function stop_Callback(hObject, eventdata, handles)

global data
data.AbortKey = true;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Single_GA_Step

% Esta funci�n lleva a cabo todos los pasos necesarios para generar una
% nueva poblaci�n a partir de la anterior y de los criterios de
% reproducci�n.
% Se incluyen las consideraciones sobre migraci�n, escalado, selecci�n,
% generaci�n por cruce y generaci�n por mutaci�n.
% Los resultados se guardan en las variables globales correspondientes.

global config data T;

if ~isfield(data,'Generation')
    data.Generation = 0;
end

% Se realiza una migraci�n si corresponde.

Migration;

% Inicializaci�n de variables.

offset = 0;
totalPop = config.GA.PopSize;

% El bucle que viene a continuaci�n se repetir� para cada sub-polaci�n; es
% decir, para cada elemento del vector "config.GA.PopSize".

for pop = 1:length(totalPop)
    
    % Inicializaci�n de variables de la sub-poblaci�n actual.
    
    data.SubPopSize =  totalPop(pop);
    ind = 1 + (offset:(offset + data.SubPopSize - 1));
    data.CurrentSubPop = data.CurrentPop(ind,:);
    data.SubPopScore = data.PopScore(ind);

    % C�lculo del n�mero de hijos generados con cada m�todo.
    
    N_Elite_K = config.GA.NumElite;
    N_Cross_K = round(config.GA.CrossFraction*(data.SubPopSize-N_Elite_K));
    N_Mutated_K = data.SubPopSize-N_Elite_K-N_Cross_K;

    % C�lculo del n�mero de padres totales necesarios para cubrir la demada
    % de hijos.
    
    nParents = 2*N_Cross_K + N_Mutated_K;
    data.NParents = nParents;

    % Escalado de expectativas de contribuir a la pr�xima generaci�n.
    
    data.Expectation = feval(config.GA.ScalingFcn);
    
    % Selecci�n de los padres de la pr�xima generaci�n. La variable
    % "parents" contiene los �ndices de los padres de la sub-poblaci�n
    % actual.

    parents = feval(config.GA.SelectionFcn);
    data.Parents = parents(randperm(length(parents)));

    [us,k] = sort(data.SubPopScore);

    % Creaci�n de los individuos de la pr�xima generaci�n.
    
    % Individuos �lite.
    
    Elite_K  = data.CurrentSubPop(k(1:N_Elite_K),:);

    % Individuos por cruce.
    
    Cross_K = feval(config.GA.CrossoverFcn,data.Parents(1:(2*N_Cross_K)));

    % Individuos por mutaci�n.
    
    Mutated_K = feval(config.GA.MutationFcn,...
        data.Parents((1+2*N_Cross_K):end));
       
    % Agrupaci�n de todos los individuos en la nueva poblaci�n.
    
    nextPopulation = [ Elite_K ; Cross_K ; Mutated_K ];
    nextPopulation = saturate(nextPopulation,data.HardRange);
    data.CurrentPop(ind,:) = nextPopulation;
    offset = offset + data.SubPopSize;
    
end 

data.Generation = data.Generation + 1;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Migration

% En esta funci�n se lleva a cabo el proceso de migraci�n de individuos
% entre subpoblaciones

global config data T;

if((length(config.GA.PopSize) == 1) ||...
        rem(data.Generation,config.GA.MigrationInterval) ~= 0)
    return
end

populations = config.GA.PopSize;

%C�lculo de �ndices.

lengths = cumsum(populations);
lengths = lengths(1:(end-1));
starts = [1, 1 + lengths];
ends = starts + populations - 1;
subPops = [starts;ends];

% N�mero de emigrantes de cada sub-poblaci�n.

N_Migr = round(populations * config.GA.MigrationFraction);
forward  = min(N_Migr,[N_Migr(2:end),N_Migr(1)]);
backward = forward([end,1:(end-1)]);
indicies = cell(1,length(populations));
newcomers = cell(1,length(populations));

% Identificaci�n de los individuos que migran a otra sub-poblaci�n.

for pop = 1:length(populations)
    p = subPops(:,pop);

    % �ndices de la sub-poblaci�n.
    
    [us,i] = sort(data.PopScore(p(1):p(2)));
    sourcePop = i(:) + p(1) - 1;
    
    % Destino de los emigrantes.
    
    ahead = 1 + mod(pop,length(populations));  
    newcomers{ahead} = [newcomers{ahead};sourcePop(1:forward(pop))]; 
    
    % Direcci�n de migraci�n. El n�mero 2 indica que habr� migraci�n hacia
    % delante y hacia atr�s. En caso contrario la migraci�n ser� en una
    % sola direcci�n.
    
    if config.GA.MigrationDirection == 2
        behind = 1 + mod(pop-2,length(populations));
        newcomers{behind} = [newcomers{behind};sourcePop(1:backward(pop))];
    end
    
    indicies{pop} = sourcePop;
end

% Movimiento de los individuos seleccionados a su correspondiente
% subpoblaci�n.

for i = 1:length(populations)
    from = newcomers{i};
    
    % Individuos reemplazados.
    
    pop = indicies{i};
    n = length(from);
    to = pop((end-n + 1):end);
    
    % Emigraci�n.
    
    data.CurrentPop(to,:) = data.CurrentPop(from,:);
    data.PopScore(to) = data.PopScore(from);
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function [y,datalog] = saturate(matriz_ent,limites)

% Esta funcion limita los valores de las columnas de la entrada 
% "matriz_ent" a los correspondientes valores m�nimo y m�ximo especificados
% en la fila 1 y fila 2 respectivamente, y en la correspondiente columna de
% la entrada "limites".
% As� pues, dada una "matriz_ent" de 6x4, la entrada "limites" deber� ser 
% de 2x6. Por ejemplo, limites=[0,-10,-5,0,4,6;2,10,10,10,10,8] indica que 
% la salida "y" ser� una matriz con los mismos valores que "matriz_ent"
% pero el valor m�ximo de la columna 1 ser� 2 y el m�nimo ser� 0. En la
% columna 2 el m�ximo ser� 10 y el m�nimo ser� -10; en la columna 3 el
% m�ximo ser� 10 y el m�nimo ser� -5, etc

% La variable "datalog" ser� una matriz de las mismas dimensiones que
% "matriz_ent". En cada posici�n habr� un 1 si se ha realizado una
% saturaci�n debida al valor m�ximo permitido, un 0 si no se ha realizado
% saturaci�n, y un -1 si se ha realizado una saturaci�n debida al valor
% m�nimo

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