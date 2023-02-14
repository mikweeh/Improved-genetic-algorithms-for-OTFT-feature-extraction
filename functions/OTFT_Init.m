function OTFT_Init

% Esta función tiene como objetivo inicializar los valores necesarios para 
% poder dar paso al algoritmo de extracción de parámetros.
% Véase que en el caso de que se habilite un algoritmo genético, debería
% generarse en esta función la población inicial.

% En primer lugar se procede al cálculo del parámetro Io, que no precisa de
% un método iterativo.

global config data T;

ind = find(T.Ids_Vds_meas(1,:)==0);
if isempty(ind)
    [us,ind] = min(abs(T.Ids_Vds_meas(1,:)));
end
Io = T.Ids_Vds_meas(2,ind);

% A continuación se genera una población de 100 individuos. Todos ellos
% tendrán una resistencia T.R y una Io igual a la recién calculada.
% Además, una parte de ellos tendrán valores significativos (habituales) de
% los parámetros, mientras que otros serán completamente aleatorios dentro
% del rango de valores que puede alcanzar cada variable.

%Valores significativos

p{1} = [-10;0;10]; %Vth
p{2} = [0.2;1.8;3.5]; %Gamma_a
p{3} = [0.5;1.5;3]; %Alfa
p{4} = [1]; %Vaa
p{5} = 0; %Lambda
p{6} = T.R; %R
p{7} = [0.3;2;4]; %m
p{8} = Io; %Io

len = [length(p{1}),length(p{2}),length(p{3}),length(p{4}),...
    length(p{5}),length(p{6}),length(p{7}),length(p{8})];
filas = prod(len);

% Rangos dentro de los cuales se encontrarán las combinaciones aleatorias.

ranges = data.HardRange;
ranges(:,5) = [0;0];
ranges(:,6) = [p{6};p{6}];
ranges(:,7) = [3;5];
ranges(:,8) = [Io;Io];

for k = 8:-1:1
    
    % Generación de las combinaciones de interés.
    
    reps = prod(len(k:end))/len(k);
    columna = replica(p{k},reps);
    population(:,k) = repmat(columna,filas/length(columna),1);
    
    % Generación de valores aleatorios
    
    population2(:,k) = ranges(1,k) + (ranges(2,k) - ...
        ranges(1,k)) * rand(sum(config.GA.PopSize) - filas,1);
end

data.CurrentPop = [population;population2];
%data.CurrentPop(end,:) = [-10,1,0.3,1000,0,0,2.7,0];

% Ahora hay que calcular los valores adecuados de Vaa en esta población
% inicial.

% Familia de curvas, curva y valores de corriente significativos.

familia=T.Ids_Vgs_meas;
curva=[familia(1,:);familia(2,:)];
Vds=curva(2,1);
I=curva(2,2:end);
I_max=max(I);
I_min=min(I);

% Corriente al 50% de la máxima en la curva actual.

I_ref=0.5*(I_max-I_min)+I_min;

% Coordenada de esa corriente.

[us,coord]=min((I-I_ref).^2);
coord=coord+1; %Coordenada de la corriente buscada

% Tensión Vgs en el punto objetivo.

Vgs=curva(1,coord);

% Corriente medida en el punto objetivo.

I_meas=curva(2,coord);

% Se guardan los datos extraidos en los campos correspondientes a los
% parámetros que precisa el método directo de extracción de Vaa.

data.DM.IMeasOp = I_meas;
data.DM.VdsOp = Vds;
data.DM.VgsOp = Vgs;

% Obtención de los valores de Vaa en cada individuo

feval(config.DMFcn);

% Cálculo del error (función de fitting)

us = feval(config.FitnessFcn,[]);

%--------------------------------------------------------------------------
function y = replica(columna,n)

% Esta pequeña función es sólo una ayuda para una operación que deberá
% repetirse varias veces. Consiste en replicar cada valor de una matriz
% columna n veces, de manera que queda una matriz columna n veces mayor.
% Es decir, si se escribe:
% replica([10;20;30],2)
% el resultado será
% [10;10;20;20;30;30];

y = [];
for k = 1:size(columna,1)
    y = [y;repmat(columna(k,1),n,1)];
end
