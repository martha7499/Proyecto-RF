classdef Analisis_frequenci
    properties
        frequencies
        Y11
        Y12
        Y21
        Y22
        S11
        S12
        S21
        S22
    end
    methods
        function obj=Analisis_frequenci(Name,arg3,A_red,nLines,f_min,f_max,f_step)
                obj.frequencies = f_min:f_step:f_max; % Vector de frecuencias
                omega = 2 * pi * obj.frequencies;    % Frecuencia angular
                
                % Calcular número de puntos
                n_points = round((f_max - f_min) / f_step) + 1;
                
                ImpedanceM = A_red;
                
                for k1 = 1:nLines
                    
                    switch Name{k1}(1)
                        case {'R', 'L', 'C'} % Passive elements
                            switch Name{k1}(1)
                                case 'R'
                                    val = str2double(arg3{k1});  % Convertir el texto a número
                                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                    syms(comp_name);  % Definir el símbolo
                                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                                    % disp(ImpedanceM);
                                case 'L'
                                    val = str2double(arg3{k1});  % Convertir el texto a número
                                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                    syms(comp_name);  % Definir el símbolo
                                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                                    % disp(ImpedanceM);
                                case 'C'
                                    val = str2double(arg3{k1});  % Convertir el texto a número
                                    comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                    syms(comp_name);  % Definir el símbolo
                                    ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                                    % disp(ImpedanceM);
                            end
                    end
                end
                
                % Inicializar una celda para almacenar los resultados
                results = cell(length(omega), 1);
                
                syms w;
                ImpedanceM_Num = ImpedanceM;
                
                % Ciclo for para sustituir w por los valores definidos
                
                for i = 1:length(omega)
                    % Sustituir w con el valor actual en la matriz A
                    ImpedanceM_Num = subs(ImpedanceM, w, omega(i));
                    
                    % Convertir el resultado a notación científica (con vpa)
                    ImpedanceM_Num = vpa(ImpedanceM_Num); 
                    
                    % Guardar el resultado en la celda
                    results{i} = ImpedanceM_Num;
                    
                    % Mostrar el resultado actual en formato exponencial
                    % fprintf('Resultado para w = %e:\n', omega(i));
                    % disp(ImpedanceM);
                    % disp(ImpedanceM_Num);
                end
                
                
                % Crear arreglos para almacenar los valores de Yij
                obj.Y11 = zeros(length(omega), 1);
                obj.Y12 = zeros(length(omega), 1);
                obj.Y21 = zeros(length(omega), 1);
                obj.Y22 = zeros(length(omega), 1);
                
                % Inicializar matrices S
                obj.S11 = zeros(1, n_points);
                obj.S12 = zeros(1, n_points);
                obj.S21 = zeros(1, n_points);
                obj.S22 = zeros(1, n_points);
                
                Z0 = 50; % Impedancia característica
                
                % Extraer los valores de las matrices de admitancia
                for i = 1:length(omega)
                    % Obtener la matriz simbólica de cada celda
                    Y_matrix = results{i};
                    
                    % Extraer valores complejos
                    obj.Y11(i) = Y_matrix(1, 1);
                    obj.Y12(i) = Y_matrix(1, 2);
                    obj.Y21(i) = Y_matrix(2, 1);
                    obj.Y22(i) = Y_matrix(2, 2);
                    
                    S_f = Y_to_S(Y_matrix, Z0);   % Convertir a S
                    obj.S11(i) = S_f.S(1, 1);
                    obj.S12(i) = S_f.S(1, 2);
                    obj.S21(i) = S_f.S(2, 1);
                    obj.S22(i) = S_f.S(2, 2);
                    
                end
        end
    end
end