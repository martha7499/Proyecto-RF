function [T11, T12, T21, T22, freq, f_min, f_max, f_step, S_params] = S2pToT(fname, Z0)
    % Cargar el archivo Touchstone
    % t=LEER_S2P('TouchStoneFiles/PB_Total.s2p');
    [freq, f_min, f_max, f_step, S_params] = read_touchstone(fname);
    % s_params = sparameters('TouchStoneFiles/Pasa_banda.s2p'); % Reemplaza con tu archivo
    % frec = s_params.Frequencies; % Frecuencias en Hz
    % s_matrix = s_params.Parameters; % Matriz S (complejas
    %z0 = s_params.Impedance; % Impedancia característica (por defecto 50 ohms)
    
    Z11 = zeros(length(freq), 1);
    Z12 = zeros(length(freq), 1);
    Z21 = zeros(length(freq), 1);
    Z22 = zeros(length(freq), 1);

    T11 = zeros(length(freq), 1);
    T12 = zeros(length(freq), 1);
    T21 = zeros(length(freq), 1);
    T22 = zeros(length(freq), 1);

    % Convertir los parámetros S a otros dominios
     for k = 1:length(freq)
        % S11(i) = S_params(1, 1);
        % S12(i) = S_params(1, 2);
        % S21(i) = S_params(2, 1);
        % S22(i) = S_params(2, 2);

        Z_matrix = S_to_Z(S_params{k, 1}, Z0);   % Convertir a S
        Z11(k) = Z_matrix(1, 1);
        Z12(k) = Z_matrix(1, 2);
        Z21(k) = Z_matrix(2, 1);
        Z22(k) = Z_matrix(2, 2);

        T = S_to_T(S_params{k, 1});
        T11(k) = T(1, 1);
        T12(k) = T(1, 2);
        T21(k) = T(2, 1);
        T22(k) = T(2, 2);
     end
    
     % fprintf("Matriz T\n");
     % disp(T11(1));
     % disp(T12(1));
     % disp(T21(1));
     % disp(T22(1));


     % R = [Z11, Z12, Z21, Z22, freq, f_min, f_max, f_step];
    % y_matrix = s2y(s_matrix, z0); % Convertir S a Y
    % abcd_matrix = s2abcd(s_matrix, z0); % Convertir S a ABCD
    % 
    % % Convertir ABCD a mtriz T (Transmisión)
    % [n_ports, ~, n_freqs] = size(abcd_matrix); % Asumimos sistema de 2 puertos
    % t_matrix = zeros(size(abcd_matrix)); % Inicializar matriz T
    % for k = 1:n_freqs
    %     A = abcd_matrix(1,1,k);
    %     B = abcd_matrix(1,2,k);
    %     C = abcd_matrix(2,1,k);
    %     D = abcd_matrix(2,2,k);
    %     t_matrix(:,:,k) = [A B; C D] ./ D; % Normalización para obtener T
    % end
end


% [T11, T12, T21, T22, freq, f_min, f_max, f_step, S11, S12, S21, S22] = S2pToT(50);
% [T11, T12, T21, T22, freq, f_min, f_max, f_step, Z11, Z12, Z21, Z22] = S2pToT(50)
% [T, freq, f_min, f_max, f_step] = S2pToT(50)