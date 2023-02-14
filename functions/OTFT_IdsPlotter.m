function OTFT_IdsPlotter(handles)

% Esta función es la específica que se usará con los transistores OTFT.
% Sólo recibe como parámetro la variable "handles", que contiene las
% variables globales habituales "config", "data" y "T". Esto es debido a
% que tendrá que operar con los objetos gráficos del programa.
% Por una parte será necesario extraer la información que se quiere mostrar
% en las gráficas (en este caso la información referente a la intensidad) y
% por otra parte se precisa gestionar y controlar parámetros de las
% gráficas tales como identificadores de gráficas, ejes, etc.

% En este caso, las intensidades buscadas se encuentran respectivamente en
% handles.T.Ids_Vds_meas, handles.T.Ids_Vds_calc, handles.T.Ids_Vgs_meas y
% handles.T.Ids_Vgs_calc.

% Extracción de datos.

T=handles.T;
plot_meas_1 = T.Ids_Vds_meas(:,2:end);
plot_meas_2 = T.Ids_Vgs_meas(:,2:end);

dib = true;
if ((size(T.Ids_Vds_calc,1) == size(T.Ids_Vds_meas,1)) &&...
        (size(T.Ids_Vds_calc,2) == size(T.Ids_Vds_meas,2)) &&...
        (size(T.Ids_Vgs_calc,1) == size(T.Ids_Vgs_meas,1)) &&...
        (size(T.Ids_Vgs_calc,2) == size(T.Ids_Vgs_meas,2)))
    plot_calc_1 = T.Ids_Vds_calc(:,2:end);
    plot_calc_2 = T.Ids_Vgs_calc(:,2:end);
else
    dib = false;
    plot_calc_1 = [];
    plot_calc_2 = [];
end

% Selección de ejes y otros parámetros de la gráfica superior.

axes(handles.graf1);
set(handles.graf1,'NextPlot','Replace');
plot(plot_meas_1(1,:),plot_meas_1(2:end,:),'g.');
if dib == true
    v=axis;
    axis(v);
    set(handles.graf1,'NextPlot','Add');
    plot(plot_calc_1(1,:),plot_calc_1(2:end,:),'b.');
end

% Selección de ejes y otros parámetros de la gráfica inferior.

axes(handles.graf2);
set(handles.graf2,'NextPlot','Replace');
plot(plot_meas_2(1,:),plot_meas_2(2:end,:),'g.');
if dib == true
    v=axis;
    axis(v);
    set(handles.graf2,'NextPlot','Add');
    plot(plot_calc_2(1,:),plot_calc_2(2:end,:),'b.');
end
drawnow
