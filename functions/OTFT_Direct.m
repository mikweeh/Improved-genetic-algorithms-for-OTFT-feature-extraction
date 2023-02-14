function OTFT_Direct

global config data T

% Esta funci�n devuelve el valor de la inc�gnita Vaa partiendo de la base
% de que se conocen todos los dem�s valores.
% Debe conocerse los valores escalares de Vds, Vgs, I_meas en el punto de
% inter�s (50% de la corriente Ids-Vgs)
% Como entradas precisa el struct T. Tienen que estar completados
% convenientemente los campos referentes al punto de operaci�n (T.Op)
% Adem�s tambi�n hay que darle la poblaci�n de individuos en la cual se
% calcular� el valor de Vaa. La salida es el valor de Vaa que se actualiza
% dentro de la variable data.CurrentPop

currentPop = data.CurrentPop;

% Recopilaci�n de todas las variables con sus nombres de proyecto para una
% mejor comprensi�n.

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

% Ecuaci�n de la corriente en funci�n de todos los par�metros (modelo
% UMEM). En este caso se despeja el par�metro Vaa.

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
