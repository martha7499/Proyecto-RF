clear
close all
clc

%% Recognizing netlist in archive
fprintf('\nStarting reading process ... please be patient.\n\n');

format short e;

%% Print out the netlist
fprintf('Netlist:\n');
fname = "CircuitsExamples/example3.cir";  % Modify with your file path
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

fprintf('\nThe n-port A matrix (before reduction): \n');
disp(A_n);

%% Reduction of the n-port network to a 2-port network using Kron
% Partition the A_n matrix into internal and external nodes
internal_nodes = 3:n;  % Assuming nodes 3 to n are internal
external_nodes = [1, 2];  % Ports

% Submatrices
A_ee = A_n(external_nodes, external_nodes);  % External nodes
A_ei = A_n(external_nodes, internal_nodes); % External-Internal coupling
A_ie = A_n(internal_nodes, external_nodes); % Internal-External coupling
A_ii = A_n(internal_nodes, internal_nodes); % Internal nodes

% Kron reduction
A_red = A_ee - A_ei * (A_ii \ A_ie);

fprintf('\nThe reduced 2-port A matrix:\n');
disp(A_red);

fprintf('\nElapsed time is %g seconds.\n', toc);


%% FREQUENCY ANALYSIS

% Definir rango de frecuencias
f_min = 1e9; % Frecuencia mínima (Hz)
f_max = 10e9; % Frecuencia máxima (Hz)
f_step = 10e6; % Paso de frecuencia (Hz)
frequencies = f_min:f_step:f_max; % Vector de frecuencias
omega = 2 * pi * frequencies;    % Frecuencia angular

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
                case 'L'
                    val = str2double(arg3{k1});  % Convertir el texto a número
                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                    syms(comp_name);  % Definir el símbolo
                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                case 'C'
                    val = str2double(arg3{k1});  % Convertir el texto a número
                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                    syms(comp_name);  % Definir el símbolo
                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
            end
    end
end

% Inicializar una celda para almacenar los resultados
results = cell(length(omega), 1);

syms w;

% Ciclo for para sustituir w por los valores definidos

for i = 1:length(omega)
    % Sustituir w con el valor actual en la matriz A
    ImpedanceM = subs(ImpedanceM, w, omega(i));
    
    % Convertir el resultado a notación científica (con vpa)
    ImpedanceM = vpa(ImpedanceM); 
    
    % Guardar el resultado en la celda
    results{i} = ImpedanceM;
    
    % Mostrar el resultado actual en formato exponencial
    fprintf('Resultado para w = %e:\n', omega(i));
    % disp(ImpedanceM_numeric);
end


% Crear arreglos para almacenar los valores de Yij
Y11 = zeros(length(omega), 1);
Y12 = zeros(length(omega), 1);
Y21 = zeros(length(omega), 1);
Y22 = zeros(length(omega), 1);

% Extraer los valores de las matrices de admitancia
for i = 1:length(omega)
    % Obtener la matriz simbólica de cada celda
    Y_matrix = results{i};
    
    % Extraer valores complejos
    Y11(i) = Y_matrix(1, 1);
    Y12(i) = Y_matrix(1, 2);
    Y21(i) = Y_matrix(2, 1);
    Y22(i) = Y_matrix(2, 2);
end

% Graficar en carta rectangular
figure; % Crear nueva ventana
plot(omega, abs(Y11), 'b', 'LineWidth', 1.5); hold on;
plot(omega, abs(Y12), 'r', 'LineWidth', 1.5);
plot(omega, abs(Y21), 'g', 'LineWidth', 1.5);
plot(omega, abs(Y22), 'm', 'LineWidth', 1.5);
hold off;
title('Parámetros de Admitancia: Magnitud (Rectangular)');
xlabel('Frecuencia (\omega)');
ylabel('Magnitud |Y_{ij}|');
legend({'Y_{11}', 'Y_{12}', 'Y_{21}', 'Y_{22}'}, 'Location', 'Best');
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

% Graficar en carta de Smith
figure; % Crear nueva ventana
smithplot; % Inicializar carta de Smith
hold on;
smithplot(Y11, 'b', 'LineWidth', 1.5); % Graficar Y11
smithplot(Y12, 'r', 'LineWidth', 1.5); % Graficar Y12
smithplot(Y21, 'g', 'LineWidth', 1.5); % Graficar Y21
smithplot(Y22, 'm', 'LineWidth', 1.5); % Graficar Y22
hold off;
title('Carta de Smith: Parámetros de Admitancia');
legend({'Y_{11}', 'Y_{12}', 'Y_{21}', 'Y_{22}'}, 'Location', 'Best');






%% Display elapsed time
fprintf('\nElapsed time is %g seconds.\n', toc);
