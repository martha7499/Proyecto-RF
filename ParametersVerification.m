clear 
close all
clc

% Cargar el archivo Touchstone
s_params = sparameters('TouchStoneFiles/Pasa_banda.s2p'); % Reemplaza con tu archivo
frec = s_params.Frequencies; % Frecuencias en Hz
s_matrix = s_params.Parameters; % Matriz S (compleja)
z0 = s_params.Impedance; % Impedancia característica (por defecto 50 ohms)

% Convertir los parámetros S a otros dominios
z_matrix = s2z(s_matrix, z0); % Convertir S a Z
y_matrix = s2y(s_matrix, z0); % Convertir S a Y
abcd_matrix = s2abcd(s_matrix, z0); % Convertir S a ABCD

% Convertir ABCD a matriz T (Transmisión)
[n_ports, ~, n_freqs] = size(abcd_matrix); % Asumimos sistema de 2 puertos
t_matrix = zeros(size(abcd_matrix)); % Inicializar matriz T
for k = 1:n_freqs
    A = abcd_matrix(1,1,k);
    B = abcd_matrix(1,2,k);
    C = abcd_matrix(2,1,k);
    D = abcd_matrix(2,2,k);
    t_matrix(:,:,k) = [A B; C D] ./ D; % Normalización para obtener T
end

% Graficar Parámetros S, Z, Y, ABCD, T
figure;

% Parámetros S
subplot(3, 2, 1);
for i = 1:n_ports
    for j = 1:n_ports
        hold on;
        plot(frec/1e9, 20*log10(abs(squeeze(s_matrix(i,j,:)))), 'LineWidth', 1.5);
    end
end
xlabel('Frecuencia (GHz)');
ylabel('Magnitud |S| (dB)');
title('Parámetros S');
grid on;
legend(arrayfun(@(i, j) sprintf('S_{%d%d}', i, j), repmat(1:n_ports, n_ports, 1), repmat((1:n_ports)', 1, n_ports), 'UniformOutput', false));

% Parámetros Z
subplot(3, 2, 2);
for i = 1:n_ports
    for j = 1:n_ports
        hold on;
        plot(frec/1e9, real(squeeze(z_matrix(i,j,:))), 'LineWidth', 1.5);
    end
end
xlabel('Frecuencia (GHz)');
ylabel('Re(Z) (\Omega)');
title('Parámetros Z');
grid on;

% Parámetros Y
subplot(3, 2, 3);
for i = 1:n_ports
    for j = 1:n_ports
        hold on;
        plot(frec/1e9, abs(squeeze(y_matrix(i,j,:))), 'LineWidth', 1.5);
    end
end
xlabel('Frecuencia (GHz)');
ylabel('|Y| (S)');
title('Parámetros Y');
grid on;

% Parámetros ABCD
subplot(3, 2, 4);
for i = 1:2 % Solo para sistemas de 2 puertos (ABCD es 2x2)
    for j = 1:2
        hold on;
        plot(frec/1e9, abs(squeeze(abcd_matrix(i,j,:))), 'LineWidth', 1.5);
    end
end
xlabel('Frecuencia (GHz)');
ylabel('|ABCD|');
title('Parámetros ABCD');
grid on;

% Parámetros T
subplot(3, 2, 5);
for i = 1:2 % Solo para sistemas de 2 puertos (T es 2x2)
    for j = 1:2
        hold on;
        plot(frec/1e9, abs(squeeze(t_matrix(i,j,:))), 'LineWidth', 1.5);
    end
end
xlabel('Frecuencia (GHz)');
ylabel('|T|');
title('Parámetros T');
grid on;

% Ajustar el diseño
sgtitle('Parámetros S, Z, Y, ABCD, T');


