function OTFT_Control

% Esta función implementa los controladores de los distintos parámetros. Es
% aquí donde se introduce el conocimiento experto del funcionamiento de la
% función.
% Este conocimiento se basa en el punto de la curva de intensidad en el
% cual se hará más patente la influencia de una determinada variable.

global config data T;

% Ganancia de los controladores

gain = [8,-8,8,-8];


% Variable Vth

% Curvas de corriente medida y calculada.

curve_meas = [T.Ids_Vgs_meas(1:2,:)];
curve_calc = [T.Ids_Vgs_calc(1:2,:)];
I = curve_meas(2,2:end);

% Puntos significativos de la curva.

Vds = curve_meas(2,1);
I_max = max(I);
I_min = min(I);

% Punto de comparación entre la corriente calculada y la medida. En este
% caso se toma la corriente al 5% de la máxima.

I_ref = 0.05 * (I_max-I_min) + I_min;

% Coordenada de esa corriente.

[us,coord_m] = min((I-I_ref).^2);
coord_m = coord_m + 1;

% Intensidades en el punto de operación.

I_meas = curve_meas(2,coord_m);
I_calc = curve_calc(2,coord_m);

% Error.

aux= I_calc - I_meas;

% Controlador proporcional al error en pu.

ent = gain(1)*(aux)/(I_max - I_min);

% Saturación del controlador.

entrada = saturate(ent,[-1;1]);

% Salida del controlador.

data.ControllerOutput{1} = entrada;


% Variable Gamma_a

% Corriente al 95% de la máxima.

I_ref = 0.95 * (I_max-I_min) + I_min;

% Coordenada de esa corriente.

[us,coord_m] = min((I-I_ref).^2);
coord_m = coord_m + 1;

% Corrientes, error y controlador proporcional.

I_meas = curve_meas(2,coord_m);
I_calc = curve_calc(2,coord_m);
ent = gain(2)*(I_calc - I_meas)/(I_max - I_min);
entrada = saturate(ent,[-1;1]);
data.ControllerOutput{2} = entrada;


% Variable Alfa.

% Curvas de corriente.

curve_meas = [T.Ids_Vds_meas(1:2,:)];
curve_calc = [T.Ids_Vds_calc(1:2,:)];
I = curve_meas(2,2:end);

% Puntos significativos de la curva.

Vgs = curve_meas(2,1);
I_max = max(I);
I_min = min(I);

% Corriente al 20% de la máxima.

I_ref = 0.2 * (I_max-I_min) + I_min;

% Coordenada de esa corriente.

[us,coord_m] = min((I-I_ref).^2);
coord_m = coord_m + 1;

% Corrientes, error y controlador proporcional.

I_meas = curve_meas(2,coord_m);
I_calc = curve_calc(2,coord_m);
ent = gain(3)*(I_calc - I_meas)/(I_max - I_min);
entrada = saturate(ent,[-1;1]);
data.ControllerOutput{3} = entrada;


% Variable m

% Corriente al 80% de la máxima.

I_ref = 0.8 * (I_max-I_min) + I_min;

% Coordenada de esa corriente.

[us,coord_m] = min((I-I_ref).^2);
coord_m = coord_m + 1;

% Corrientes, error y controlador proporcional.

I_meas = curve_meas(2,coord_m);
I_calc = curve_calc(2,coord_m);
ent = gain(4)*(I_calc - I_meas)/(I_max - I_min);
entrada = saturate(ent,[-1;1]);
data.ControllerOutput{7} = entrada;


% Las otras salidas de los controladores no cambian.

data.ControllerOutput{4} = 0;
data.ControllerOutput{5} = 0;
data.ControllerOutput{6} = 0;
data.ControllerOutput{8} = 0;

