function [T11, T12, T21, T22, freq, f_min, f_max, f_step, S_params, S11_x, S12_x, S21_x, S22_x, T_x] = S2pToT(fname, Z0)
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
    T_x = {};

    S11_x = zeros(length(freq), 1);
    S12_x = zeros(length(freq), 1);
    S21_x = zeros(length(freq), 1);
    S22_x = zeros(length(freq), 1);
    S_x = {};

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
        T_x{k, 1} = {T11(k), T12(k); T21(k), T22(k)};
        
        S11_x(k) = T21(k)./T11(k);
        S12_x(k) = ((T11(k)*T22(k))-(T21(k)*T12(k)))./(T11(k));
        S21_x(k) = 1./T11(k);
        S22_x(k) = -(T22(k)./T11(k));
        S_x{k, 1} = {S11_x(k), S12_x(k); S21_x(k), S22_x(k)};
    end

    T_x = cellfun(@(expr) sym(expr), T_x, 'UniformOutput',false);
    S_x = cellfun(@(expr) sym(expr), S_x, 'UniformOutput',false);
    
    % matrix = 'S';
    % SmithGraph(f_min, f_max, -S11_x, -S12_x, -S21_x, -S22_x, matrix);

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