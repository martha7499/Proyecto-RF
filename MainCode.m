clear
close all
clc


%% Recognizing netlist in archive and Generating N-node Matriz.
fprintf('\nStarting reading process ... please be patient.\n\n');


[Name,N1, N2, arg3, n, m, nLines, nPortM, G] = MatrixGenerator("CircuitsExamples/example3.cir");

fprintf('\nThe n-port A matrix (before reduction): \n');
disp(nPortM);

%% the n-port network reduction

Y_Matrix = NPortReduction(n, nPortM, G);

%%  %% FREQUENCY ANALYSIS
 % Definir rango de frecuencias
f_min = 1e9; % Frecuencia mínima (Hz)
f_max = 100e9; % Frecuencia máxima (Hz)
f_step = 100e6; % Paso de frecuencia (Hz)
[Y11, Y12, Y21, Y22, S11, S12, S21, S22, Y_num, S_f, frequencies] = FrequencyAnalysis(Name, nLines, f_min, f_max, f_step, Y_Matrix, arg3);

%% Graph
% 
% matrix = 'Y';
% RectangularGraph(Y11, Y12, Y21, Y22, matrix, frequencies);
% 
% matrix = 'S';
% SmithGraph(f_min, f_max, S11, S12, S21, S22, matrix);
% 
% matrix = 'Y';
% PolarGraph(Y11, Y12, Y21, Y22, matrix);

%%
t=LEER_S2P('TouchStoneFiles/PB_Total.s2p');