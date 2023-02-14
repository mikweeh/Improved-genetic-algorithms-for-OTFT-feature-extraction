function OTFT_Direct

global config data T

% Esta función devuelve el valor de la incógnita Vaa partiendo de la base
% de que se conocen todos los demás valores.
% Debe conocerse los valores escalares de Vds, Vgs, I_meas en el punto de
% interés (50% de la corriente Ids-Vgs)
% Como entradas precisa el struct T. Tienen que estar completados
% convenientemente los campos referentes al punto de operación (T.Op)
% Además también hay que darle la población de individuos en la cual se
% calculará el valor de Vaa. La salida es el valor de Vaa que se actualiza
% dentro de la variable data.CurrentPop

currentPop = data.CurrentPop;

% Recopilación de todas las variables con sus nombres de proyecto para una
% mejor comprensión.

n_ind = size(currentPop,1);
Ids = repmat(data.DM.IMeasOp,n_ind,1);
Vds = repmat(data.DM.VdsOp,n_ind,1);
Vgs = repmat(data.DM.VgsOp,n_ind,1);
Vth = currentPop(:,1);
K = repmat(T.K,n_ind,1);
g = currentPop(:,2);
Alfa = currentPop(:,3);
Lambda = currentPop(:,5);
R = currentPop(:,6);
m = currentPop(:,7);
Io = currentPop(:,8);

% Ecuación de la corriente en función de todos los parámetros (modelo
% UMEM). En este caso se despeja el parámetro Vaa.

warning off;
Vaa=abs(exp((log(-K.*(Vds+Vds.^2.*Lambda+Io.*(1+...
    (Vds./Alfa./(Vgs-Vth)).^m).^(1./m).*R-Ids.*(1+...
    (Vds./Alfa./(Vgs-Vth)).^m).^(1./m).*R)./(Io-Ids)).*...
    m-log(1+(Vds./Alfa./(Vgs-Vth)).^m)+...
    log(Vgs-Vth).*m.*g+log(Vgs-Vth).*m)./m./g));

if any(isnan(Vaa))
     Vaa(find(isnan(Vaa)==true)) = Inf;
end

data.CurrentPop(:,4) = abs(Vaa);
warning on;
