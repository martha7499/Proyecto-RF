classdef Y_to_S
    properties
        S
    end
    methods
           function obj = Y_to_S(Y, Z0)
    % Convertir matriz de admitancia Y a matriz de dispersión S
    % Parámetros:
    %   Y: Matriz 2x2 de admitancia
    %   Z0: Impedancia característica (valor escalar, típicamente 50 ohms)
    % Salida:
    %   S: Matriz 2x2 de dispersión

    % Verificar que Y sea 2x2
    if size(Y, 1) ~= 2 || size(Y, 2) ~= 2
        error('La matriz Y debe ser de tamaño 2x2.');
    end

    % Crear matriz diagonal de impedancia característica
    Z0_matrix = Z0 * eye(2);  % Matriz diagonal con Z0

    % Matriz identidad 2x2
    I = eye(2);

    % Calcular S usando la fórmula: S = (Y*Z0 + I)^(-1) * (Y*Z0 - I)
    YZ0 = Y * Z0_matrix;           % Producto Y*Z0
    obj.S = (YZ0 + I) \ (YZ0 - I);     % División matricial: (YZ0 + I)^(-1) * (YZ0 - I)
end

        end
end
