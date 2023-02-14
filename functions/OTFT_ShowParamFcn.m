function OTFT_ShowParamFcn(handles)

% Esta funci�n se utiliza para definir los par�metros que se quieren
% mostrar por pantalla a cada iteraci�n. Esta funci�n recibe como par�metro
% la variable "handles" en lugar de las variables globales habituales 
% "config", "data" y "T", porque tendr� que actuar sobre los objetos
% gr�ficos de salida.

[data,T] = deal(handles.data,handles.T);

% Lista 1 del entorno gr�fico.

str_subs = {'Vth = '; ...
        'Gamma = '; ...
        'Alfa = '; ...
        'Vaa = '; ...
        'Lambda = '; ...
        'R = ';...
        'm = ';...
        'Io = '};
for k = 1:length(T.Indiv)
    str_aux{k} = [str_subs{k} num2str(T.Indiv(k))];
end
set(handles.list1,'String',str_aux);

% Lista 2 del entorno gr�fico.

str_subs_2 = {'Iteraci�n = '; ...
              'Error[pu] = '; ...
              'Tiempo[s] = '};
current_value = [data.GlobalIter, ...
                 data.BestScore, ...
                 round(10*(cputime - data.StartTime))/10];
for k=1:3
    str_aux_2{k} = [str_subs_2{k} num2str(current_value(k))];
end
set(handles.list2,'String',str_aux_2); 
