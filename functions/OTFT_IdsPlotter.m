function OTFT_IdsPlotter(handles)

% Esta funci�n es la espec�fica que se usar� con los transistores OTFT.
% S�lo recibe como par�metro la variable "handles", que contiene las
% variables globales habituales "config", "data" y "T". Esto es debido a
% que tendr� que operar con los objetos gr�ficos del programa.
% Por una parte ser� necesario extraer la informaci�n que se quiere mostrar
% en las gr�ficas (en este caso la informaci�n referente a la intensidad) y
% por otra parte se precisa gestionar y controlar par�metros de las
% gr�ficas tales como identificadores de gr�ficas, ejes, etc.

% En este caso, las intensidades buscadas se encuentran respectivamente en
% handles.T.Ids_Vds_meas, handles.T.Ids_Vds_calc, handles.T.Ids_Vgs_meas y
% handles.T.Ids_Vgs_calc.

% Extracci�n de datos.

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

% Selecci�n de ejes y otros par�metros de la gr�fica superior.

axes(handles.graf1);
set(handles.graf1,'NextPlot','Replace');
plot(plot_meas_1(1,:),plot_meas_1(2:end,:),'g.');
if dib == true
    v=axis;
    axis(v);
    set(handles.graf1,'NextPlot','Add');
    plot(plot_calc_1(1,:),plot_calc_1(2:end,:),'b.');
end

% Selecci�n de ejes y otros par�metros de la gr�fica inferior.

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
