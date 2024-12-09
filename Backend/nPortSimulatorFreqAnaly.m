clear
close all
clc

%% Recognizing netlist in archive
fprintf('\nStarting reading process ... please be patient.\n\n');

% format short e;

%% Print out the netlist
fprintf('Netlist:\n');
fname = "CircuitsExamples/PasaBajas.cir";  % Modify with your file path
fid = fopen(fname);
fileIn = textscan(fid, '%s %s %s %s %s %s');
[Name, N1, N2, arg3, arg4, arg5] = fileIn{:};
fclose(fid);

nLines = length(Name); 

N1 = str2double(N1);   % Get node numbers
N2 = str2double(N2);

tic                  % Begin timing.

n = max([N1; N2]);    % Number of nodes in the circuit

m = 0; 
for k1 = 1:nLines                 
    switch Name{k1}(1)
        case {'V', 'O', 'E', 'H'}  
            m = m + 1;             
    end
end

% Initializing matrices for the circuit components
G = sym(zeros(n, n));  
B = sym(zeros(n, m));
C = sym(zeros(m, n));
D = sym(zeros(m, m));
i = sym(zeros(n, 1));
e = sym(zeros(m, 1));
j = sym(zeros(m, 1));
v = sym('v_', [n, 1], 'real'); 

vsCnt = 0;

% Constructing G, B, C, D matrices for the circuit components
for k1 = 1:nLines
    n1 = N1(k1);  
    n2 = N2(k1);
    
    switch Name{k1}(1)
        case {'R', 'L', 'C'} % Passive elements
            switch Name{k1}(1)
                case 'R'
                    g = str2sym(['1/' Name{k1}]);
                case 'L'
                    g = str2sym(['1/(1j*w*' Name{k1} ')']);
                case 'C'
                    g = str2sym(['1j*w*' Name{k1}]);
            end
            if (n1 == 0)
                G(n2, n2) = G(n2, n2) + g;  
            elseif (n2 == 0)
                G(n1, n1) = G(n1, n1) + g;  
            else
                G(n1, n1) = G(n1, n1) + g;
                G(n2, n2) = G(n2, n2) + g;  
                G(n1, n2) = G(n1, n2) - g;  
                G(n2, n1) = G(n2, n1) - g;  
            end
            
        case 'V' % Independent voltage source
            vsCnt = vsCnt + 1;  
            if n1 ~= 0
                B(n1, vsCnt) = B(n1, vsCnt) + sym(1);         
                C(vsCnt, n1) = C(vsCnt, n1) + sym(1);
            end
            if n2 ~= 0
                B(n2, vsCnt) = B(n2, vsCnt) - sym(1);         
                C(vsCnt, n2) = C(vsCnt, n2) - sym(1);
            end
            e(vsCnt) = str2sym(Name{k1});         
            j(vsCnt) = str2sym(['I_' Name{k1}]);  
            
        case 'I' % Independent current source
            if n1 ~= 0
                i(n1) = i(n1) - str2sym(Name{k1}); 
            end
            if n2 ~= 0
                i(n2) = i(n2) + str2sym(Name{k1}); 
            end
    end
end

% Completing CCVS and CCCS elements
for k1 = 1:nLines
    n1 = N1(k1);
    n2 = N2(k1);
    switch Name{k1}(1)
        case 'H'
            cv = str2sym(arg3{k1});  
            cvInd = find(j == cv);  
            hInd = find(j == str2sym(Name{k1})); 
            D(hInd, cvInd) = -str2sym(Name{k1});
        case 'F'
            cv = str2sym(arg3{k1}); 
            cvInd = find(j == cv);  
            if n1 ~= 0
                B(n1, cvInd) = B(n1, cvInd) + str2sym(Name{k1});
            end
            if n2 ~= 0
                B(n2, cvInd) = B(n2, cvInd) - str2sym(Name{k1});
            end
    end
end

% Form the n-port A matrix
A_n = [G, B; C, D];
nPortM = G;

fprintf('\nThe n-port A matrix (before reduction): \n');
disp(A_n);
A_red = G;

%% Reduction of the n-port network to a 2-port network using Kron

if n > 2
    fprintf('\nThe n-port A matrix (before reduction): \n');
    disp(A_n);

    % Partition the A_n matrix into internal and external nodes
    internal_nodes = 2:n-1;  % Assuming nodes 3 to n are internal
    external_nodes = [1, n];  % Ports
    
    % Submatrices
    A_ee = nPortM(external_nodes, external_nodes);  % External nodes
    A_ei = nPortM(external_nodes, internal_nodes); % External-Internal coupling
    A_ie = nPortM(internal_nodes, external_nodes); % Internal-External coupling
    A_ii = nPortM(internal_nodes, internal_nodes); % Internal nodes
    
    % Kron reduction
    A_red = A_ee - A_ei * (A_ii \ A_ie);
    
    fprintf('\nThe reduced 2-port A matrix:\n');
    disp(A_red);
    
    fprintf('\nElapsed time is %g seconds.\n', toc);
else
    fprintf('\nThe 2-port matrix: \n');
    A_red = G;
    disp(A_red);
end


%% FREQUENCY ANALYSIS

% Definir rango de frecuencias
f_min = 1e6; % Frecuencia mínima (Hz)
f_max = 100e6; % Frecuencia máxima (Hz)
f_step = 100e3; % Paso de frecuencia (Hz)
frequencies = f_min:f_step:f_max; % Vector de frecuencias
omega = 2 * pi * frequencies;    % Frecuencia angular

% Calcular número de puntos
n_points = round((f_max - f_min) / f_step) + 1;

ImpedanceM = A_red;

for k1 = 1:nLines
    
    switch Name{k1}(1)
        case {'R', 'L', 'C'} % Passive elements
            switch Name{k1}(1)
                case 'R'
                    val = str2double(arg3{k1});  % Convertir el texto a número
                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                    syms(comp_name);  % Definir el símbolo
                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                    % disp(ImpedanceM);
                case 'L'
                    val = str2double(arg3{k1});  % Convertir el texto a número
                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                    syms(comp_name);  % Definir el símbolo
                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                    % disp(ImpedanceM);
                case 'C'
                    val = str2double(arg3{k1});  % Convertir el texto a número
                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                    syms(comp_name);  % Definir el símbolo
                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                    % disp(ImpedanceM);
            end
    end
end

% Inicializar una celda para almacenar los resultados
results = cell(length(omega), 1);

syms w;
ImpedanceM_Num = ImpedanceM;

% Ciclo for para sustituir w por los valores definidos

for i = 1:length(omega)
    % Sustituir w con el valor actual en la matriz A
    ImpedanceM_Num = subs(ImpedanceM, w, omega(i));
    
    % Convertir el resultado a notación científica (con vpa)
    ImpedanceM_Num = vpa(ImpedanceM_Num); 
    
    % Guardar el resultado en la celda
    results{i} = ImpedanceM_Num;
    
    % Mostrar el resultado actual en formato exponencial
    % fprintf('Resultado para w = %e:\n', omega(i));
    % disp(ImpedanceM);
    % disp(ImpedanceM_Num);
end


% Crear arreglos para almacenar los valores de Yij
Y11 = zeros(length(omega), 1);
Y12 = zeros(length(omega), 1);
Y21 = zeros(length(omega), 1);
Y22 = zeros(length(omega), 1);

% Inicializar matrices S
S11 = zeros(1, n_points);
S12 = zeros(1, n_points);
S21 = zeros(1, n_points);
S22 = zeros(1, n_points);

Z0 = 50; % Impedancia característica

% Extraer los valores de las matrices de admitancia
for i = 1:length(omega)
    % Obtener la matriz simbólica de cada celda
    Y_matrix = results{i};
    
    % Extraer valores complejos
    Y11(i) = Y_matrix(1, 1);
    Y12(i) = Y_matrix(1, 2);
    Y21(i) = Y_matrix(2, 1);
    Y22(i) = Y_matrix(2, 2);
    
    S_f = Y_to_S(Y_matrix, Z0);   % Convertir a S
    S11(i) = S_f(1, 1);
    S12(i) = S_f(1, 2);
    S21(i) = S_f(2, 1);
    S22(i) = S_f(2, 2);
    
end

% Graficar en carta rectangular
% Graficar resultados
figure;
subplot(2, 2, 1);
plot(frequencies, abs(Y11), 'b', 'LineWidth', 1.5);
title('|Y_{11}| vs Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('|Y_{11}| (S)');
grid on;

subplot(2, 2, 2);
plot(frequencies, abs(Y12), 'r', 'LineWidth', 1.5);
title('|Y_{12}| vs Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('|Y_{12}| (S)');
grid on;

subplot(2, 2, 3);
plot(frequencies, abs(Y21), 'r', 'LineWidth', 1.5);
title('|Y_{12}| vs Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('|Y_{12}| (S)');
grid on;

subplot(2, 2, 4);
plot(frequencies, abs(Y22), 'r', 'LineWidth', 1.5);
title('|Y_{12}| vs Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('|Y_{12}| (S)');
grid on;

% Graficar en forma polar
figure; % Crear nueva ventana
polarplot(angle(Y11), abs(Y11), 'b', 'LineWidth', 1.5); hold on;
polarplot(angle(Y12), abs(Y12), 'r', 'LineWidth', 1.5);
polarplot(angle(Y21), abs(Y21), 'g', 'LineWidth', 1.5);
polarplot(angle(Y22), abs(Y22), 'm', 'LineWidth', 1.5);
hold off;
title('Parámetros de Admitancia: Forma Polar');
legend({'Y_{11}', 'Y_{12}', 'Y_{21}', 'Y_{22}'}, 'Location', 'Best');

% % Graficar en la Carta de Smith
frequenciesA = linspace(1e6, 100e6, length(S11)); % Frecuencias igualmente espaciadas
frequenciesB = linspace(1e6, 100e6, length(S12)); % Frecuencias igualmente espaciadas
frequenciesC = linspace(1e6, 100e6, length(S21)); % Frecuencias igualmente espaciadas
frequenciesD = linspace(1e6, 100e6, length(S22)); % Frecuencias igualmente espaciadas
% smithplot(frequencies, S11);


figure;

subplot(2, 2, 1);
smithplot(frequenciesA, -S11);
title('S(1,1)');
grid on;

subplot(2, 2, 2);
smithplot(frequenciesB, -S12);
title('S(1,2)');
grid on;

subplot(2, 2, 3);
smithplot(frequenciesC, -S21);
title('S(2,1)');
grid on;

subplot(2, 2, 4);
smithplot(frequenciesD, -S22);
title('S(2,2)');
grid on;

% Configuración general
sgtitle('Gráfica de parámetros S en la Carta de Smith (1 GHz a 10 GHz)');

%% Display elapsed time
fprintf('\nElapsed time is %g seconds.\n', toc);


%% Funciones

function S = Y_to_S(Y, Z0)
    % Convertir matriz de admitancia Y a matriz de dispersión S
    % Parámetros:
    %   Y: Matriz 2x2 de admitancia
    %   Z0: Impedancia característica (valor escalar, típicamente 50 ohms)
    % Salida:
    %   S: Matriz 2x2 de dispersión

    % Verificar que Y sea 2x2
    if size(Y, 1) ~= 2 || size(Y, 2) ~= 2
        error('La matriz Y debe ser de tamaño 2x2.');
    end

    % Crear matriz diagonal de impedancia característica
    Z0_matrix = Z0 * eye(2);  % Matriz diagonal con Z0

    % Matriz identidad 2x2
    I = eye(2);

    % Calcular S usando la fórmula: S = (Y*Z0 + I)^(-1) * (Y*Z0 - I)
    YZ0 = Y * Z0_matrix;           % Producto Y*Z0
    S = (YZ0 + I) \ (YZ0 - I);     % División matricial: (YZ0 + I)^(-1) * (YZ0 - I)
end