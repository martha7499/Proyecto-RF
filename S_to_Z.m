function Z = S_to_Z(S, Z0)
    % Crear matriz diagonal de impedancia característica
    Z0_matrix = Z0 * eye(2);  % Matriz diagonal con Z0

    % Matriz identidad 2x2
    I = eye(2);

    Z = Z0_matrix*((I+S)\(I-S));
end