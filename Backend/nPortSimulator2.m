clear;
close all;
clc;

% --- Configuración inicial y lectura de la netlist ---
fprintf('\nStarting reading process ... please be patient.\n\n');
format short e;

% Leer archivo de netlist
fname = "CircuitsExamples/example5_PasaAltas.cir"; % Cambia el archivo según corresponda
fid = fopen(fname);
fileIn = textscan(fid, '%s %s %s %s %s %s');
[Name, N1, N2, arg3, arg4, arg5] = fileIn{:};
fclose(fid);

N1 = str2double(N1); % Nodos del componente
N2 = str2double(N2);
nLines = length(Name);

n = max([N1; N2]); % Número total de nodos
m = 0; % Contador para fuentes de voltaje

% Inicialización de matrices simbólicas
G = sym(zeros(n, n));  % Matriz de conductancias
B = sym(zeros(n, m));
C = sym(zeros(m, n));
D = sym(zeros(m, m));

% Construcción de las matrices del circuito
for k1 = 1:nLines
    n1 = N1(k1);
    n2 = N2(k1);
    switch Name{k1}(1)
        case 'R'
            g = str2sym(['1/' Name{k1}]);
            if n1 ~= 0
                G(n1, n1) = G(n1, n1) + g;
            end
            if n2 ~= 0
                G(n2, n2) = G(n2, n2) + g;
            end
            if n1 ~= 0 && n2 ~= 0
                G(n1, n2) = G(n1, n2) - g;
                G(n2, n1) = G(n2, n1) - g;
            end
        case 'L'
            g = str2sym(['1/(1j*w*' Name{k1} ')']);
            % Similar al caso de resistencias
        case 'C'
            g = str2sym(['1j*w*' Name{k1}]);
            % Similar al caso de resistencias
    end
end

% Matriz n-por-n del circuito
A_n = G; % Ajustar si hay más fuentes

fprintf('\nThe n-port A matrix (before reduction):\n');
disp(A_n);

% --- Reducción de Kron ---
internal_nodes = 2:n;  % Nodos internos (ajustar según el circuito)
external_nodes = [1, 3];  % Nodos externos (puertos)

A_ee = A_n(external_nodes, external_nodes);  % Submatriz de nodos externos
A_ei = A_n(external_nodes, internal_nodes); % Nodos externos e internos
A_ie = A_n(internal_nodes, external_nodes); % Nodos internos y externos
A_ii = A_n(internal_nodes, internal_nodes); % Nodos internos

% Reducción de Kron
A_red = A_ee - A_ei * (A_ii \ A_ie);

fprintf('\nThe reduced 2-port A matrix:\n');
disp(A_red);

% --- Sustitución de parámetros en función de frecuencia ---
f_min = 1e9; % Frecuencia mínima (Hz)
f_max = 10e9; % Frecuencia máxima (Hz)
f_step = 10e6; % Paso de frecuencia (Hz)
frequencies = f_min:f_step:f_max; % Vector de frecuencias
omega = 2 * pi * frequencies;

% Sustitución de componentes simbólicos
syms w;
for i = 1:nLines
    switch Name{i}(1)
        case 'R'
            A_red = subs(A_red, str2sym(['1/' Name{i}]), 1 / str2double(arg3{i}));
        case 'L'
            A_red = subs(A_red, str2sym(['1/(1j*w*' Name{i} ')']), 1 / (1j * omega * str2double(arg3{i})));
        case 'C'
            A_red = subs(A_red, str2sym(['1j*w*' Name{i}]), 1j * omega * str2double(arg3{i}));
    end
end

% Resultados para parámetros Yij
Y11 = double(subs(A_red(1, 1), w, omega));
Y12 = double(subs(A_red(1, 2), w, omega));
Y21 = double(subs(A_red(2, 1), w, omega));
Y22 = double(subs(A_red(2, 2), w, omega));

% Graficar resultados
figure;
plot(frequencies, abs(Y11), 'b', 'LineWidth', 1.5); hold on;
plot(frequencies, abs(Y12), 'r', 'LineWidth', 1.5);
plot(frequencies, abs(Y21), 'g', 'LineWidth', 1.5);
plot(frequencies, abs(Y22), 'm', 'LineWidth', 1.5);
hold off;
title('Parámetros Y (magnitud)');
xlabel('Frecuencia (Hz)');
ylabel('|Y_{ij}|');
legend({'Y_{11}', 'Y_{12}', 'Y_{21}', 'Y_{22}'});
grid on;
