function [freq, f_initial, f_final, f_spot, S_params] = read_touchstone(filename)
    % Lee un archivo Touchstone (*.s2p) sin utilizar RF Toolbox.
    % Outputs:
    %   freq: Vector de frecuencias en Hz.
    %   S_params: Arreglo bidimensional [N, 1] donde cada fila contiene la matriz S asociada.
    
    % Abrir el archivo
    fid = fopen(filename, 'r');
    if fid == -1
        error('No se puede abrir el archivo: %s', filename);
    end
    
    % Inicializar variables
    freq = [];
    S_params = {}; % Inicializar como un arreglo de celdas
    line_count = 0;
    
    % Leer línea por línea
    while ~feof(fid)
        line = fgetl(fid); % Leer línea
        line_count = line_count + 1;
        
        % Omitir comentarios y líneas vacías
        if startsWith(line, '#') % Encabezado de parámetros
            header = line;
        elseif startsWith(line, '!')
            continue; % Saltar comentarios
        elseif isempty(line)
            continue;
        else
            % Dividir los datos numéricos en la línea
            data = sscanf(line, '%f');
            
            % Verificar el formato del archivo
            if numel(data) == 9 % Formato para S2P
                % Leer frecuencia y los 8 elementos de la matriz S
                freq(end+1, 1) = data(1); % Frecuencia
                S_temp = [data(2) + 1j * data(3), data(4) + 1j * data(5); % S11, S12
                          data(6) + 1j * data(7), data(8) + 1j * data(9)]; % S21, S22
                S_params{end+1, 1} = S_temp; % Almacenar como celda en [freq, 1]
            else
                warning('Formato inesperado en la línea %d', line_count);
            end
        end
    end
    
    fclose(fid); % Cerrar archivo
    
    % Analizar el encabezado
    if exist('header', 'var')
        fprintf('Archivo leído con encabezado: %s\n', header);
    else
        warning('El archivo no contiene un encabezado definido.');
    end
    
    % Convertir frecuencia a Hz si el encabezado especifica otras unidades
    if contains(header, 'GHZ', 'IgnoreCase', true)
        freq = freq * 1e9;
    elseif contains(header, 'MHZ', 'IgnoreCase', true)
        freq = freq * 1e6;
    elseif contains(header, 'KHZ', 'IgnoreCase', true)
        freq = freq * 1e3;
    end

    % Definir variables adicionales
    f_initial = min(freq);
    f_final = max(freq);
    f_spot = freq(2) - freq(1); % Suponiendo paso uniforme
end



%[freq, f_min, f_max, f_step, S_params] = read_touchstone_2('TouchStoneFiles/Pasa_Bajas_2do_orden.s2p');
%[freq, f_min, f_max, f_step, S_params] = read_touchstone_2('TouchStoneFiles/Pasa_banda.s2p');
% [freq, f_min, f_max, f_step, S_params] = read_touchstone_2('TouchStoneFiles/PB_Total.s2p');
% [freq, f_min, f_max, f_step, S_params] = read_touchstone_2('TouchStoneFiles/ATF-38143_Vgs_-0.55_Vds_2.s2p');
% [freq, f_min, f_max, f_step, S_params] = read_touchstone_2('TouchStoneFiles/Line.s2p');