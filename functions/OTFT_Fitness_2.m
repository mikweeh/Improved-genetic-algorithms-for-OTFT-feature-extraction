function [y] = OTFT_Fitness_2(incog)

% Esta función es prácticamente igual en cuanto a funcionalidad que la
% llamada "OTFT_Fitness". La diferencia principal está en que ésta no
% trabaja con matrices de 3D, es decir, está preparada sólo para el cálculo
% del error de un individuo para toda una familia de curvas. De esta manera
% se gana mucha velocidad en los cálculos.
% Por otra parte, la variable de entrada "incog" debe contener el valor de
% las variables que componen el individuo-solución a evaluar. Sin embargo,
% no es necesario que contenga todos los genes (las 8 variables) ya que si
% falta alguna ésta será completada de los datos presentes en la variable
% global data.BestIndiv. De esta forma se puede lanzar el método matemático
% sobrelas variables desadas.

global config data T;
format long;

% Ordenación de los datos de cada variable.

varindex = data.MM.VarIndex;
variables = data.BestIndiv;
variables(varindex) = incog;
Vt = variables(1,1);
gamma_a = variables(1,2);
alfa = variables(1,3);
Vaa = variables(1,4);
lambda = variables(1,5);
R = variables(1,6);
m = variables(1,7);
Io = variables(1,8);
K = T.K;

y = 0;
for k = 1:2
    if k==1
        
        %Curvas Ids-Vds
        
        Ids_meas = T.Ids_Vds_meas(2:end,2:end);
        n_samples=size(T.Ids_Vds_meas,2)-1;
        n_curves=size(T.Ids_Vds_meas,1)-1;
        Vgs=T.Ids_Vds_meas(2:end,1);
        Vds=T.Ids_Vds_meas(1,2:end);
        I_max = max(max(Ids_meas));
        I_min = min(min(Ids_meas));
    else
        
        %Curvas Ids-Vgs
        
        Ids_meas = T.Ids_Vgs_meas(2:end,2:end)';
        Vgs=T.Ids_Vgs_meas(1,2:end)';
        Vds=T.Ids_Vgs_meas(2:end,1)';
        n_samples=size(T.Ids_Vgs_meas,1)-1;
        n_curves=size(T.Ids_Vgs_meas,2)-1;
    end

    %Cálculo
    
    warning('OFF','MATLAB:divideByZero');
    
    % Primer miembro de la ecuación UMEM.

    a0=(Vgs-Vt+sqrt((Vgs-Vt).^2))/2;
    a1=(a0.^(-1*(gamma_a+1)));
    a2=a1*(Vaa^gamma_a)/K+R;
    a3=a2.^(-1);

    % Segundo miembro de la ecuación UMEM.
    
    b0=(lambda*Vds+1).*Vds;
    b0_1 = alfa*a0;
    b1=(1./(alfa*a0))*Vds;
    b2=(b1.^m+1).^(1./m);
    b3=repmat(b0,[n_curves,1])./b2;

    % Tercer miembro de la ecuación UMEM.
    
    c0=repmat(a3,[1,n_samples]).*b3+Io;
    c0(find(isnan(c0)==true))=0;

    % Error.
    
    c1 = ((c0 - Ids_meas)/(I_max-I_min)).^2;
    
    %Resultados
    
    if k==1
        y=sum(sum(c1));
        N1 = prod(size(Ids_meas));
        clear a0 a1 a2 a3 b0 b0_1 b1 b2 b3 c0 c1
    else
        N2 = prod(size(Ids_meas));
        y = sqrt(y + sum(sum(c1)))/sqrt(N1+N2);
        h=1;
    end
end
warning('ON','MATLAB:divideByZero');