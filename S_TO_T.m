function [z_matrix, y_matrix] = S_to_T(s_matrix, frequencies, );
    % Cargar el archivo Touchstone
    t=LEER_S2P('TouchStoneFiles/PB_Total.s2p');

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
end

classdef S_to_T
    properties
        T
    end
    methods
        function obj=S_to_T(input,n)
            obj.T=cell(n,n);
            dt=(-1*(det(vpa(input))));
            obj.T{1,1}=vpa(dt/(input{2,1}),4);
            obj.T{1,2}=vpa((input{1,1})/(input{2,1}),4);
            obj.T{2,1}=vpa((-1*(input{2,2}))/input{2,1},4);
            obj.T{2,2}=vpa(1/input{2,1},4);
        end
        function displayT(obj)
            disp('MATRIZ DE T');
            disp(obj.T);
        end
    end
end
