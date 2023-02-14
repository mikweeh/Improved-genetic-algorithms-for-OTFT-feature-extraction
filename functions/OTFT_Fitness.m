function error = OTFT_Fitness(CurrentPop)

% Funci�n que eval�a la adaptaci�n de un conjunto de individuos-soluci�n
% guardados en la variable CurrentPop (un individuo en cada fila).
% No se pasa ning�n otro par�metro a la funci�n porque en el bucle
% principal se usan variables globales.

global config data T;
format long;

% Esta funci�n monta matrices de 3D para hacer los c�lculos. En la primera
% dimensi�n (filas) se listan los individuos; en la segunda dimensi�n
% (columnas) se listan los puntos de tensi�n del eje de abscisas, y en la
% tercera dimensi�n (capas) se listan los puntos de tensi�n identificativos
% de cada curva. Por ejemplo, en la 1� dimensi�n habr�a 100 individuos, en
% la segunda dimensi�n las 401 muestras de Vds desde 0 a 40V cogidas de
% 0.1V en 0.1V, y en la tercera dimensi�n habr�a el valor de Vgs de cada
% curva, por ejemplo, Vgs=40V, Vgs=30V, Vgs=20V y Vgs=10V.


% Los datos de entrada que usa esta funci�n son:
% data.CurrentPop --> La poblaci�n actual
% (este mismo dato puede introducirse directamente en la variable de
% entrada "CurrentPop")

%T.W
%T.L
%T.K
%T.Ids_Vds_meas
%T.Ids_Vgs_meas


%Los datos de salida que tiene que completar esta funci�n son:
% error --> Error del individuo mejor adaptado.
% data.PopScore --> El error de cada individuo.
% data.BestScore --> El error m�nimo (es lo mismo qe la variable error)
% data.BestIndivIndex --> El �ndice del mejor individuo.
% data.BestIndiv --> El mejor individuo (los genes)
% T.Ids_Vds_calc --> La familia de curvas calculadas
% T.Ids_Vgs_calc --> La familia de curvas calculadas
% T.Indiv --> El individuo con el cual se han calculado las familias de
% curvas anteriores (normalmente ser� el mejor individuo)

% Si no se da ning�n valor a la variable de entrada CurrentPop, el programa
% coger� como valor de esta variable el que est� guardado en el campo
% "CurrentPop" de la variable global "data".

if ~isempty(CurrentPop)
    if size(CurrentPop,2) ~= config.GA.NumVars
        ind1 = T.Indiv;
        ind1(1,data.MM.VarIndex) = CurrentPop;
        data.CurrentPop = ind1;
    else
        data = rmfield(data,'CurrentPop');
        data.CurrentPop = CurrentPop;
    end
end

% Ordenaci�n de los datos de cada variable.

Vt = data.CurrentPop(:,1);
gamma_a = data.CurrentPop(:,2);
alfa = data.CurrentPop(:,3);
Vaa = data.CurrentPop(:,4);
lambda = data.CurrentPop(:,5);
R = data.CurrentPop(:,6);
m = data.CurrentPop(:,7);
Io = data.CurrentPop(:,8);

W = T.W;
L = T.L;
n_ind = size(data.CurrentPop,1);
K = T.K;

warning('OFF','MATLAB:divideByZero');
for k = 1:2
    if k == 1
        
        %Curvas Ids-Vds
        
        n_samples = size(T.Ids_Vds_meas,2)-1;
        n_curves = size(T.Ids_Vds_meas,1)-1;
        Vgs = T.Ids_Vds_meas(2:end,1)';
        Vds = T.Ids_Vds_meas(1,2:end);
        I_ds = T.Ids_Vds_meas(2:end,2:end);
        I_max = max(max(I_ds));
        I_min = min(min(I_ds));
        I_meas2(1,:,:) = I_ds';
        I_meas3 = repmat(I_meas2,[n_ind,1,1]);
    else
        
        %Curvas Ids-Vgs
        
        n_samples = size(T.Ids_Vgs_meas,1)-1;
        n_curves = size(T.Ids_Vgs_meas,2)-1;
        Vgs = T.Ids_Vgs_meas(1,2:end);
        Vds = T.Ids_Vgs_meas(2:end,1)';
        I_ds = T.Ids_Vgs_meas(2:end,2:end);
        I_meas2(1,:,:) = I_ds;
        I_meas3 = repmat(I_meas2,[n_ind,1,1]);
    end

    %C�lculo
    
    %Filas=n_ind; Columnas=n_samples; Capas=n_curves
    %R�plicas para respetar el formato c�bico.
    
    Vgs2(1,1,:) = Vgs;
    Vgs3 = repmat(Vgs2,[n_ind,n_samples,1]);
    Vt3 = repmat(Vt,[1,n_samples,n_curves]);
    gamma_a3 = repmat(gamma_a,[1,n_samples,n_curves]);
    Vaa3 = repmat(Vaa,[1,n_samples,n_curves]);
    R3 = repmat(R,[1,n_samples,n_curves]);
    lambda2 = repmat(lambda,1,n_samples);
    Vds2 = repmat(Vds,n_ind,1);
    alfa3 = repmat(alfa,[1,n_samples,n_curves]);
    m3 = repmat(m,[1,n_samples,n_curves]);
    Io3 = repmat(Io,[1,n_samples,n_curves]);

    % Primer miembro de la ecuaci�n UMEM.
    
    a0 = (Vgs3-Vt3+sqrt((Vgs3-Vt3).^2)).*0.5;
    a1 = a0.^(-1*(gamma_a3+1));
    a2 = a1.*Vaa3.^gamma_a3/K+R3;
    a3 = 1./a2;
        
    % Segundo miembro de la ecuaci�n UMEM.
    
    b0 = (lambda2.*Vds2+1).*Vds2; 
    b1 = repmat(Vds2,[1,1,n_curves])./(alfa3.*a0);
    b2 = (b1.^m3+1).^(1./m3);
    b3 = repmat(b0,[1,1,n_curves])./b2;

    %Tercer miembro de la ecuaci�n UMEM.
    
    c0 = a3.*b3+Io3;
    c0(find(isnan(c0)==true))=0;
    
    %Error

    c1 = ((c0 - I_meas3)/(I_max-I_min)).^2;
    
    %Resultados

    if k == 1
        data.PopScore = sum(sum(c1,3),2);
        N1 = size(I_meas3,2)*size(I_meas3,3);
        aux = c0;
        clear a0 a1 a2 a3 b* c0 c1 Vgs* Vds* Vt3 gamma_a3 Vaa3 R3 lambda2
        clear alfa3 m3 I_ds I_meas2 I_meas3
    else
        N2 = size(I_meas3,2)*size(I_meas3,3);
        data.PopScore = sqrt(data.PopScore + sum(sum(c1,3),2))/sqrt(N1+N2);
        [data.BestScore,data.BestIndivIndex] = min(data.PopScore);
        error = data.BestScore;
        data.BestIndiv = data.CurrentPop(data.BestIndivIndex,:);
        ids_vds_calc(:,:) = aux(data.BestIndivIndex,:,:);
        T.Ids_Vds_calc = [T.Ids_Vds_meas(:,1),...
            [T.Ids_Vds_meas(1,2:end);ids_vds_calc']];
        ids_vgs_calc(:,:) = c0(data.BestIndivIndex,:,:);
        T.Ids_Vgs_calc = [T.Ids_Vgs_meas(:,1),...
            [T.Ids_Vgs_meas(1,2:end);ids_vgs_calc]];
        T.Indiv = data.BestIndiv;
    end
end
warning('ON','MATLAB:divideByZero');