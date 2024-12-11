clear
close all
clc


%% Recognizing netlist in archive and Generating N-node Matriz.
fprintf('\nStarting reading process ... please be patient.\n\n');


[Name,N1, N2, arg3, n, m, nLines, nPortM, G] = MatrixGenerator("CircuitsExamples/example5_PasaAltas.cir");

fprintf('\nThe n-port A matrix (before reduction): \n');
disp(nPortM);

%% the n-port network reduction

Y_Matrix = NPortReduction(n, nPortM, G);

%%  %% FREQUENCY ANALYSIS
 % Definir rango de frecuencias
f_min = 1e6; % Frecuencia mínima (Hz)
f_max = 100e6; % Frecuencia máxima (Hz)
f_step = 1e6; % Paso de frecuencia (Hz)
[Y11, Y12, Y21, Y22, S11, S12, S21, S22, Y_num, S_matrix, frequencies] = FrequencyAnalysis(Name, nLines, f_min, f_max, f_step, Y_Matrix, arg3);

%% Graph

matrix = 'Y';
RectangularGraph(Y11, Y12, Y21, Y22, matrix, frequencies, 'dB');

matrix = 'S';
SmithGraph(f_min, f_max, S11, S12, S21, S22, matrix);
 
matrix = 'S';
PolarGraph(S11, S12, S21, S22, matrix);

%% Convert Netlist S to T
T11_N = zeros(length(frequencies), 1);
T12_N = zeros(length(frequencies), 1);
T21_N = zeros(length(frequencies), 1);
T22_N = zeros(length(frequencies), 1);

disp(S_matrix{1, 1});

X =cellfun(@(expr) sym(expr),S_matrix, 'UniformOutput',false);

for k = 1:length(frequencies)
    TN = S_to_T(X{k, 1});
    T11_N(k) = TN(1, 1);
    T12_N(k) = TN(1, 2);
    T21_N(k) = TN(2, 1);
    T22_N(k) = TN(2, 2);
end



%% s2p to T

Z0 = 50;
fname = 'TouchStoneFiles/Pasa_altas_2do_orden.s2p';
[T11, T12, T21, T22, freq, f_initial, f_final, f_spot, S_params, S11_x, S12_x, S21_x, S22_x, T_x] = S2pToT(fname, Z0);

matrix = 'S_x';
SmithGraph(f_initial, f_final, -S11_x, -S12_x, -S21_x, -S22_x, matrix);

matrix = 'T';
SmithGraph(f_initial, f_final, T11, T12, T21, T22, matrix);

%% T Cascade
% Tx = CascadeT(TA, TB);