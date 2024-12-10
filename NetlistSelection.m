clear
close all
clc


fprintf('Procesando Netlist...\n');

% Leer el archivo de netlist
fname = "CircuitsExamples/example9.cir"; % Ruta del archivo
fid = fopen(fname);
fileIn = textscan(fid, '%s %s %s %s %s %s', 'Delimiter', ' ');
[Name, N1, N2, arg3, arg4, arg5] = fileIn{:};
fclose(fid);

% Inicializar variables
sub_netlist_1 = {}; % Netlist antes de S2p
sub_netlist_2 = {}; % Netlist después de S2p
node_map = containers.Map(); % Mapeo de nodos para renumerar
new_node_counter = 1; % Contador de nuevos nodos
found_S2p = false; % Bandera para detectar S2p

% Procesar la netlist
for i = 1:length(Name)
    % Detectar el símbolo S2p
    if strcmp(Name{i}, 'S2p')
        found_S2p = true;
        node_map = containers.Map(); % Reiniciar mapeo de nodos para la segunda sub-netlist
        new_node_counter = 1; % Reiniciar contador de nodos
        continue; % No incluir S2p en ninguna sub-netlist
    end
    
    % Construir la línea
    if ~found_S2p
        % Agregar líneas antes de S2p directamente a la primera netlist
        line_parts = {Name{i}, N1{i}, N2{i}};
        if i <= length(arg3) && ~isempty(arg3{i}), line_parts{end + 1} = arg3{i}; end
        if i <= length(arg4) && ~isempty(arg4{i}), line_parts{end + 1} = arg4{i}; end
        if i <= length(arg5) && ~isempty(arg5{i}), line_parts{end + 1} = arg5{i}; end
        sub_netlist_1{end + 1} = strjoin(line_parts, ' ');
    else
        % Renumerar nodos para líneas después de S2p
        if ~isKey(node_map, N1{i}) && ~strcmp(N1{i}, '0')
            node_map(N1{i}) = new_node_counter;
            new_node_counter = new_node_counter + 1;
        end
        if ~isKey(node_map, N2{i}) && ~strcmp(N2{i}, '0')
            node_map(N2{i}) = new_node_counter;
            new_node_counter = new_node_counter + 1;
        end
        
        % Renumerar los nodos
        renum_N1 = N1{i};
        renum_N2 = N2{i};
        if isKey(node_map, N1{i}), renum_N1 = num2str(node_map(N1{i})); end
        if isKey(node_map, N2{i}), renum_N2 = num2str(node_map(N2{i})); end
        
        % Crear la línea renumerada
        line_parts = {Name{i}, renum_N1, renum_N2};
        if i <= length(arg3) && ~isempty(arg3{i}), line_parts{end + 1} = arg3{i}; end
        if i <= length(arg4) && ~isempty(arg4{i}), line_parts{end + 1} = arg4{i}; end
        if i <= length(arg5) && ~isempty(arg5{i}), line_parts{end + 1} = arg5{i}; end
        sub_netlist_2{end + 1} = strjoin(line_parts, ' ');
    end
end

% Guardar las sub-netlists en archivos
if ~isempty(sub_netlist_1)
    fid = fopen('sub_netlist_1.cir', 'w');
    fprintf(fid, '%s\n', sub_netlist_1{:});
    fclose(fid);
    fprintf('Sub-netlist 1 guardada en sub_netlist_1.cir\n');
end

if ~isempty(sub_netlist_2)
    fid = fopen('sub_netlist_2.cir', 'w');
    fprintf(fid, '%s\n', sub_netlist_2{:});
    fclose(fid);
    fprintf('Sub-netlist 2 guardada en sub_netlist_2.cir\n');
end
