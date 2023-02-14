function OTFT_Init

% Esta funci�n tiene como objetivo inicializar los valores necesarios para 
% poder dar paso al algoritmo de extracci�n de par�metros.
% V�ase que en el caso de que se habilite un algoritmo gen�tico, deber�a
% generarse en esta funci�n la poblaci�n inicial.

% En primer lugar se procede al c�lculo del par�metro Io, que no precisa de
% un m�todo iterativo.

global config data T;

ind = find(T.Ids_Vds_meas(1,:)==0);
if isempty(ind)
    [us,ind] = min(abs(T.Ids_Vds_meas(1,:)));
end
Io = T.Ids_Vds_meas(2,ind);

% A continuaci�n se genera una poblaci�n de 100 individuos. Todos ellos
% tendr�n una resistencia T.R y una Io igual a la reci�n calculada.
% Adem�s, una parte de ellos tendr�n valores significativos (habituales) de
% los par�metros, mientras que otros ser�n completamente aleatorios dentro
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

% Rangos dentro de los cuales se encontrar�n las combinaciones aleatorias.

ranges = data.HardRange;
ranges(:,5) = [0;0];
ranges(:,6) = [p{6};p{6}];
ranges(:,7) = [3;5];
ranges(:,8) = [Io;Io];

for k = 8:-1:1
    
    % Generaci�n de las combinaciones de inter�s.
    
    reps = prod(len(k:end))/len(k);
    columna = replica(p{k},reps);
    population(:,k) = repmat(columna,filas/length(columna),1);
    
    % Generaci�n de valores aleatorios
    
    population2(:,k) = ranges(1,k) + (ranges(2,k) - ...
        ranges(1,k)) * rand(sum(config.GA.PopSize) - filas,1);
end

data.CurrentPop = [population;population2];
%data.CurrentPop(end,:) = [-10,1,0.3,1000,0,0,2.7,0];

% Ahora hay que calcular los valores adecuados de Vaa en esta poblaci�n
% inicial.

% Familia de curvas, curva y valores de corriente significativos.

familia=T.Ids_Vgs_meas;
curva=[familia(1,:);familia(2,:)];
Vds=curva(2,1);
I=curva(2,2:end);
I_max=max(I);
I_min=min(I);

% Corriente al 50% de la m�xima en la curva actual.

I_ref=0.5*(I_max-I_min)+I_min;

% Coordenada de esa corriente.

[us,coord]=min((I-I_ref).^2);
coord=coord+1; %Coordenada de la corriente buscada

% Tensi�n Vgs en el punto objetivo.

Vgs=curva(1,coord);

% Corriente medida en el punto objetivo.

I_meas=curva(2,coord);

% Se guardan los datos extraidos en los campos correspondientes a los
% par�metros que precisa el m�todo directo de extracci�n de Vaa.

data.DM.IMeasOp = I_meas;
data.DM.VdsOp = Vds;
data.DM.VgsOp = Vgs;

% Obtenci�n de los valores de Vaa en cada individuo

feval(config.DMFcn);

% C�lculo del error (funci�n de fitting)

us = feval(config.FitnessFcn,[]);

%--------------------------------------------------------------------------
function y = replica(columna,n)

% Esta peque�a funci�n es s�lo una ayuda para una operaci�n que deber�
% repetirse varias veces. Consiste en replicar cada valor de una matriz
% columna n veces, de manera que queda una matriz columna n veces mayor.
% Es decir, si se escribe:
% replica([10;20;30],2)
% el resultado ser�
% [10;10;20;20;30;30];

y = [];
for k = 1:size(columna,1)
    y = [y;repmat(columna(k,1),n,1)];
end
