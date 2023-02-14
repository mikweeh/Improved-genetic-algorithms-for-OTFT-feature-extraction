function mutateKids = OTFT_Mutation(us)

global config data T;

% Esta función hace mutaciones a partir del individuo mejor adaptado. Las
% mutaciones serán guiadas según el resultado de un valor que deberá llegar
% en la variable data.ControllerOutput. Este valor indicará la magnitud y
% el signo de la mutación. Concretamente, este valor es la fracción de
% variación obtenida de un controlador. Indica la fracción dentro del
% rango de la correspondiente variable. Un valor de variación de 1 dará
% lugar a una desviación típica de 1/4 del rango total de la variable.

nparents = data.SubPopSize - config.GA.NumElite;

% Se carga el valor del leader y de la salida de los controladores.

leader = data.BestIndiv;
k = data.ControllerOutput(:);
k = cat(2,k{:});

% el signo de k indica el sentido del cambio.

direct = sign(k);

% Se pasa del sistema en pu al valor normalizado de cada variable.

k = k.*(data.HardRange(2,:)-data.HardRange(1,:))/4;

% Se calcula el incremento como una gaussiana con media cero y desviación
% típica k/4

inc = repmat(k,nparents,1).*randn(nparents,config.GA.NumVars);

% Se dobla la gaussiana sobre su media quedando con el signo indicado por k

inc = abs(inc).*repmat(direct,nparents,1);

% Se definen los individuos mutados según el incremento calculado.

mutateKids = inc + repmat(leader,nparents,1);

% Se saturan los individuos a los límites indicados por los ragos.

mutateKids = saturate(mutateKids,data.HardRange);

