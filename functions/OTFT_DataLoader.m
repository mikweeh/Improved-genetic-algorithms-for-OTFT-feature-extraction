function T = OTFT_DataLoader(filename)

% Esta funci�n tiene como cometido cargar todos los datos de un transistor
% de tipo OTFT. Estos datos, que ser�n tanto f�sicos como medidas, estar�n
% contenidos en un archivo de texto con extensi�n ".otft"

% Esta funci�n s�lo precisa como entrada el nombre completo (incluyendo el
% path) del documento de texto que contiene los datos. La salida ser� una
% variable de tipo "struct" que contendr� toda la informaci�n ordenada de
% la forma que se describir� a lo largo del programa.

% Se abre el archivo y se guarda todo su contenido en la variable "texto".

texto = '';
fid = fopen(filename);
texto = fread(fid, Inf,'*char')';
fclose(fid);

% A continuaci�n se cargar�n las dos matrices que aparecen en el archivo de
% texto. La primera se corresponde con los valores de Ids(Vds). Los valores
% de Vds aparecen en la primera columna, mientras que los valores de Vgs
% aparecer�n en la primera fila.
% Por su parte, la segunda matriz que se carga es la que corresponde a la
% familia de curvas Ids(Vgs). Los valores de Vds estar�n en la primera
% columna, mientras que los valores de Vgs estar�n en la primera fila.

for iter = 1:2
    
    % Se selecciona la matriz
    
    if iter == 1
        indice = strfind(texto,'Vds\Vgs') + 7;
    else
        indice = strfind(texto,'Vgs\Vds') + 7;
        clear Ids;
    end
    texto_rip = texto(indice:end);
    salida = false;
    fila = 1;
    n_column = 2;
    Ids(1,1) = 0;
    
    % En primer lugar se decodifica la primera fla de la matriz. Esto
    % indicar� el n�mero de columnas de la matriz, y por tanto podr�
    % conocerse el n�mero de curvas que se presentan.
    
    while salida == false;
        [token,texto_rip] = strtok(texto_rip);
        if strcmp(token,'Finlinea')
              salida = true;
        else
              Ids(1,n_column) = str2num(token);
              n_column = n_column + 1;
        end
    end
    
    % A continuaci�n se decodifica fila a fila todo el resto de la matriz.
    
    salida = false;
    fila = 2;
    while salida == false
          [token,texto_rip] = strtok(texto_rip);
        if strcmp(token,'Fin')
              salida = true;
        else
              Ids(fila,1) = str2num(token);
              for k = 2:n_column-1
                    [token,texto_rip] = strtok(texto_rip);
                    Ids(fila,k) = str2num(token);
              end
              fila = fila + 1;
        end
    end
    
    % Se ordena la variable tipo matriz, de tal forma que la variable que
    % define el eje quede dispuesta en la primera fila. Por otra parte, los
    % valores que definen las diferentes curvas quedar�n dispuestas en la
    % primera columna ordenados de mayor a menor en sentido descendente.
    
    Ids(1,1) = -Inf;
    aux = (sortrows(Ids))';
    aux(1,1) = Inf;
    aux=sortrows(aux,-1);
    aux(1,1) = NaN;
    if iter == 1
          T.Ids_Vds_meas=aux;
    else
          T.Ids_Vgs_meas=aux;
    end
end

% El formato en el que se dejan estas matrices para facilitar su
% representaci�n y b�squeda de datos es el siguiente:

% La matriz de familia de curvas Ids-Vds:
%  NaN    Vdsmin    Vds    Vds    Vdsmax
% Vgsmax    Ids     Ids    Ids      Ids
%  Vgs      Ids     Ids    Ids      Ids
%  Vgs      Ids     Ids    Ids      Ids
% Vgsmin    Ids     Ids    Ids      Ids

% Es decir, en la fila 1 se tiene, desde la columna 2 hasta la �ltima, los
% valores ordenados de forma creciente de Vds; o sea, el eje de abscisas.
% Adem�s, a medida que se vayan cogiendo valores de Ids de una fila
% inferior, estos se corresponder�n con un valor menor de Vgs.

% En cuanto al formato de la familia de curvas Ids-Vgs ser� an�logo.
% La matriz de familia de curvas Ids-Vds:
%  NaN    Vgsmin    Vgs    Vgs    Vgsmax
% Vdsmax    Ids     Ids    Ids      Ids
%  Vds      Ids     Ids    Ids      Ids
%  Vds      Ids     Ids    Ids      Ids
% Vdsmin    Ids     Ids    Ids      Ids
%

%A continuaci�n se extrae el valor de la constante diel�ctrica.

target_text = 'Constante diel�ctrica =';
indice = strfind(texto,target_text)+length(target_text);
if ~any(indice)
    
    % Se introduce un valor por defecto en caso de que no se encuentre
    % definido en el texto.
    
    T.Dcte = 3.9;
else
    texto_rip = texto(indice:end);
    T.Dcte = str2num(strtok(texto_rip));
end

% Se extrae el valor de el grosor del material que forma el diel�ctrico de
% la puerta.

target_text = 'Grosor del diel�ctrico de la puerta =';
indice = strfind(texto,target_text)+length(target_text);
if ~any(indice)
    T.Gdth = 1.2e-7;
else
    texto_rip = texto(indice:end);
    T.Gdth = str2num(strtok(texto_rip));
end

% Se extrae el valor de la movilidad de banda del material.

target_text = 'Movilidad de banda del material =';
indice = strfind(texto,target_text)+length(target_text);
if ~any(indice)
    T.Mu_0 = 4e-5;
else
    texto_rip = texto(indice:end);
    T.Mu_0 = str2num(strtok(texto_rip));
end

%A continuaci�n se extrae el valor del ancho del canal

target_text = 'Ancho del canal =';
indice = strfind(texto,target_text)+length(target_text);
if ~any(indice)
    T.W = 500e-6;
else
    texto_rip = texto(indice:end);
    T.W = str2num(strtok(texto_rip));
end

% Se extrae el valor de la longitud del canal

target_text = 'Largo del canal =';
indice = strfind(texto,target_text)+length(target_text);
if ~any(indice)
    T.L = 50e-6;
else
    texto_rip = texto(indice:end);
    T.L = str2num(strtok(texto_rip));
end

% Finalmente se realizan los c�lculos pertinentes para hallar el valor de
% la constante K y se inicializan algunos campos que todav�a carecen de
% valor.

C_diel=T.Dcte*8.854e-12/T.Gdth;
T.K=T.W/T.L*C_diel*T.Mu_0;
T.Indiv=[NaN NaN NaN NaN NaN NaN NaN NaN];
T.Ids_Vds_calc=[];
T.Ids_Vgs_calc=[];
T.R = 0;

% A continuaci�n se muestra cu�les son los diferentes campos que componen 
% el struct llamado T, el cual contiene toda la informaci�n necesaria sobre
% el transistor actual para poder extraer sus par�metros.

%T.Ids_Vds_meas    Matriz de curvas (medidas) de Ids-Vds. Incluye ejes.
%T.Ids_Vgs_meas    Matriz de curvas (medidas) de Ids-Vgs. Incluye ejes.
%T.Ids_Vds_calc    Matriz de curvas (calculadas) de Ids-Vds con los valores
                 % de los par�metros del transistor indicados en T.Indiv.
                 % Incluye valores de los ejes.
%T.Ids_Vgs_calc    Matriz de curvas (calculadas) de Ids-Vgs con los valores
                 % de los par�metros del transistor indicados en T.Indiv.
                 % Incluye valores de los ejes.
%T.Dcte            Constante diel�ctrica.
%T.Gdth            Grosor del diel�ctrico de la puerta.
%T.Mu_0            Movilidad.
%T.W               Ancho del canal.
%T.L               Longitud del canal.
%T.K               Constante K.
%T.Indiv           Combinaci�n de variables actual seg�n el siguiente orden
                 % [Vth,Gamma_a,Alfa,Vaa,Lambda,R,m,Io]
%T.R               Resistencia inicial drenador surtidor a efectos de
                 % c�lculo.