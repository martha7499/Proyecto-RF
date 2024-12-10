%El programa realiza los calculos de los para hacer el calculo de la
%inductancia del circuito
%% inicio del programa
fprintf('\nStarted -- please be patient.\n\n');

%%  Imprimi la netlist, 
% Descarga del archivo
fprintf('Netlist:');
type fname.txt
fid = fopen('fname.txt');
fileIn=textscan(fid,'%s %s %s %s %s %s');  % lee el archivo genera 6 conceptos por linea
% Genera 6 columnas por linea para dar lugar a los diferentes conceptos
%El primer concepto es siempre el nombre del elemento del circuito, en el
%segunod y tercer columna son los nodos del circuito, el cuarto valor es el
% valor del elemento
[Name, N1, N2, arg3, arg4, arg5] = fileIn{:};
%Elemento, nodo1, nodo2, y tres argumentos
fclose(fid);

nLines = length(Name);  %Numeros de lineas, significa el No. de elementos

N1=str2double(N1);   % Se guardan los valores de los nodos
N2=str2double(N2);

tic                  % Se inicia el tiempo

n = max([N1; N2]);   % se busca el nodo mas grande 
m=0; %m se le asignara el numero de fuentes de voltajes 
for k1=1:nLines                  % Revisa todas las lineas para encontrar las fuentes de voltaje
    switch Name{k1}(1)
        case {'V', 'O', 'E', 'H'}  % casos dentro de las fuentes x las que se incrementa m
            m = m + 1;             
    end
end
%% SEÑAL DE MUESTRA DE 
f_max = 1e9;          % Frecuencia máxima (1 GHz)
fs = 10 * f_max;      % Frecuencia de muestreo (10 veces f_max para evitar aliasing)
t_duration = 1e-6;    % Duración de la señal (1 microsegundo)

% Generar el eje temporal
t = 0:1/fs:t_duration;

% Frecuencia instantánea
f = linspace(10e6, f_max, length(t));

% Onda sinusoidal
signal = sin(2 * pi * f .* t);

%% COLOCACION DE ARREGLO LITOVSKI NOTATION
%Preasignacion de matrices para los elementos en la notacion de litovski
%para la matriz A
G=cell(n,n);  [G{:}]=deal('0');%inductancia% todas se rellenan con '0'
B=cell(n,m);  [B{:}]=deal('0');%ubicacion fuentes%Las dimensiones de cada matriz estan
C=cell(m,n);  [C{:}]=deal('0');%ubicacion fuentes%dadas  por la notacion
D=cell(m,m);  [D{:}]=deal('0');%solo cero para fuentes independientes
%para la matriz z
i=cell(n,1);  [i{:}]=deal('0');%valores de corriente atravez de elementos pasivos
e=cell(m,1);  [e{:}]=deal('0');%valores de la fue
% ntes 
%para la matriz x
j=cell(m,1);  [j{:}]=deal('0');%corrientes desconocidas de v
v=compose('v_%d',(1:n)');          %v es la matriz de fuentes

% Registro de la cantidad de fuentes en el circuito
% Inizalizamos la variable de las fuentes del circuito
vsCnt = 0;

% Este bucle realiza la mayor parte del llenado de las matrices.
% Escanea línea por línea y llena las matrices según el tipo de
% elemento que se encuentre en la línea actual.
for k1=1:nLines
    n1 = N1(k1);   %se tienen dos variables de nodos
    n2 = N2(k1);
    
    switch Name{k1}(1)
        % elementos pasivos
        case {'R','L','C','O','G','N'} % RXXXXXXX N1 N2 valor
            switch Name{k1}(1)  %se forman los valores de inductancia.
                case 'R'
                    g=['1/' Name{k1}];
                case 'L'
                    g=['1/j*w' Name{k1}];
                case 'C'
                    g=['j*w' Name{k1}];
                case 'O'
                    g='Z0*1/(tan(Bd))';
                case 'G'
                    g='Z0*tan(Bd)';
                case 'N'
                    g='Z0*(ZL+j*w*LZ0tan(Bd)/Z0+j*w*ZLtan(Bd))';
                    
            end
        % Aquí completamos la matriz G agregando conductancia.
        % El procedimiento es ligeramente diferente si uno de los nodos está
        % conectado a tierra, por lo que debe verificarlos según corresponda.
            if (n1==0)
                G{n2,n2} = sprintf('%s + %s',G{n2,n2},g);  % agrega la conductancia.
            elseif (n2==0)
                G{n1,n1} = sprintf('%s + %s',G{n1,n1},g);  % agrega la conductancia.
            else
                G{n1,n1} = sprintf('%s + %s',G{n1,n1},g);  % agrega la conductancia.
                G{n2,n2} = sprintf('%s + %s',G{n2,n2},g);  % agrega la conductancia.
                G{n1,n2} = sprintf('%s - %s',G{n1,n2},g);  % conducntancia negativa.
                G{n2,n1} = sprintf('%s - %s',G{n2,n1},g);  % conductancia negativa.
            end
            
        % fuentes de voltajes independientes.
        case 'V' % VXXXXXXX N1 N2 valor   (N1=anodo, N2=catodo)
            vsCnt = vsCnt + 1;  % Realice un seguimiento de cuál es esta fuente.
            % Ahora complete las matrices B y C (nuevamente, el proceso es ligeramente
            % diferente si uno de los nodos es tierra).
            if n1~=0
                B{n1,vsCnt} = [B{n1,vsCnt} ' + 1'];
                C{vsCnt, n1} = [C{vsCnt, n1} ' + 1'];
            end
            if n2~=0
                B{n2,vsCnt} = [B{n2,vsCnt} ' - 1'];
                C{vsCnt, n2} = [C{vsCnt, n2} ' - 1'];
            end
            e{vsCnt}=Name{k1};         % nombre de fuentes de voltaje
            j{vsCnt}=['I_' Name{k1}];  % agrega las fuentes de corriente desconocidas
    end 
end
%% MATRIZ DE VALORES
cellGen = CellMatrixGenerator(fileIn,signal);%Funcion que genera matriz de valores
cellGen.displayCellMatrix(); %despliegue de matriz de valores
values=cellGen.values;%se guarda la matriz de valores en values

%% TRANSFORMADA DE Y A Z
Z = Y_to_Z(G,n);
Z.displayZ();
dt=Z.dt;

%% TRANSFORMADA DE Y A Z CON VALORES
Z1 = Y_to_Z(values,n);
Z1.displayZ();

%% TRANSFORMADA DE Y A ABCD
ABCD = Y_to_ABCD(G,n,dt);
ABCD.displayABCD();

%% TRANSFORMADA DE Z A S
S = Z_to_S(Z.Z,n);
S.displayS();

%% TRANSFORMADA DE Z A S CON VALORES
S2 = Z_to_S(Z1.Z,n);
S2.displayS();
%% VALORES Y DATOS
% En este punto, se han analizado todas las fuentes de voltaje. Ahora podemos
% repasar y finalizar los elementos CCVS y CCCS (que dependen de la
% corriente que pasa por esas fuentes).

for k1=1:nLines
    n1 = N1(k1);
    n2 = N2(k1);
    switch Name{k1}(1)
        case 'H'
            % Aquí encontramos los índices en la matriz j:
            % de la tensión de control (cvInd)
            % así como el índice de este elemento (hInd)
            cv = arg3{k1};  % valor delos elementos
            cvInd = find(contains(j,cv));  % busca si el valor de los elementos esta en la matriz.
            hInd = find(contains(j,Name{k1})); % encuentra el indice del elementos
            D{hInd,cvInd}=['-' Name{k1}];  % coloca el valor del elementos en la matriz D.
        case 'F'
           % Aquí encontramos el índice en la matriz j del voltaje de control
           % (cvInd)
            cv = arg3{k1}; % nombre de voltajes controlados
            cvInd = find(contains(j,cv));  % indice del elemento
            % los coloca deacuerdo en la matriz B.
            if n1~=0
                B{n1,cvInd} = [B{n1,cvInd} ' + ' Name{k1}];
            end
            if n2~=0
                B{n2,cvInd} = [B{n2,cvInd} ' - ' Name{k1}];
            end
    end
end


%%  Las submatrices estan completas es mometo de unirlas en las matriz
% y resolver 

A = str2sym([G B; C D]); %Genera matriz A e imprimir
%fprintf('\nThe A matrix: \n');
%disp(A);

x=str2sym([v;j]);       %genera matriz x e imprime
%fprintf('\nThe x matrix: \n');
%disp(x);

z=str2sym([i;e]);       %genera matriz z e imprime
%fprintf('\nThe z matrix:  \n');
%disp(z);

% genera una matriz de valores simbolicos, buscando en cada matriz
syms([symvar(A), symvar(x), symvar(z)]);

a= simplify(A\z);  % Simplifica la expresion para imprimirla
%{
for i=1:length(a)  % Asigna las variables de a en cada lado del signo igual
    % para imprimirlo.
    eval(sprintf('%s = %s;',x(i),a(i)));
end
%}

%% Lastly, assign any numeric values to symbolic variables.
% Go through the elements a line at a time and see if the values are valid
% numbers.  If so, assign them to the variable name.  Then you can use
% "eval" to get numberical results.
for k1=1:nLines
    switch Name{k1}(1)
        % These circuit elements defined by three variables, 2 nodes and a
        % value.  The third variable (arg3) is the value.
        case {'R', 'L', 'C', 'V', 'I'}
            [num, status] = str2num(arg3{k1}); 
            % Elements defined by four variables, arg4 is the value.
        case {'H', 'F'}
            [num, status] = str2num(arg4{k1}); 
            % Elements defined by five variables, arg5 is the value.
        case {'E','G'}
            [num, status] = str2num(arg5{k1}); 
    end
    if status  % status will be true if the argument was a valid number.
        % If the number is valid, assign it to the variable.
        eval(sprintf('%s = %g;',Name{k1}, num));
    end
end

%% LEER ARCHIVOS S2P
% Abrir el archivo
filename = 'Line.s2p';
S2P=Leer_S2P(filename);%Clase para usarse
%% MANIPULACION DEL ARCHIVO
%% TRANSFORMADA DE S A T
T = S_to_T(S.S,n);
T.displayT();
%% TRANSFORMADA DE S A T CON VALORES 
T = S_to_T(S2.S,n);
T.displayT();
%% ESCRIBIR Y GUARDAR ARCHIVO 
T_frequencie='HZ';
T_file='S';
format='RI';
Arch=Escribir_Y_Guardar_S2P(S2P.frequencies,S2P.S11,S2P.S12,S2P.S21,S2P.S22,T_frequencie,T_file,format);
Arch.writeToFile();
%% fin del programa
fprintf('\nElapsed time is %g seconds.\n',toc);
