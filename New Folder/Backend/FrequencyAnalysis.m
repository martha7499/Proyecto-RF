clear 
% close all
clc


% Parámetros del circuito
L1 = 8.2e-6;
C1 = 130e-12;  % Capacitancia (Faradios)
C2 = 47e-12;  % Capacitancia (Faradios)
R1 = 53;
R2 = 95;

% Definir rango de frecuencias
f_min = 1e6; % Frecuencia mínima (Hz)
f_max = 100e6; % Frecuencia máxima (Hz)
f_step = 10e3; % Paso de frecuencia (Hz)
frequencies = f_min:f_step:f_max; % Vector de frecuencias
omega = 2 * pi * frequencies;    % Frecuencia angular

% Inicializar matrices para guardar resultados
Y11 = zeros(size(frequencies));
Y12 = zeros(size(frequencies));
Y21 = zeros(size(frequencies));
Y22 = zeros(size(frequencies));

% Cálculo de los términos de la matriz para cada frecuencia
for k = 1:length(omega)
    w = omega(k); % Frecuencia angular actual
    Y11(k) = C1*w*1i - 1i/(L1*w);
    Y12(k) = 1i/(L1*w);
    Y21(k) = 1i/(L1*w);
    Y22(k) = C2*w*1i - 1i/(L1*w);
end

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