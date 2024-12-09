classdef Analisis_Frecuencia
    properties
    end
    methods
        function obj=Analisis_Frecuencia(Name)
         f_min = 1e9; % Frecuencia mínima (Hz)
         f_max = 10e9; % Frecuencia máxima (Hz)
         f_step = 10e6; % Paso de frecuencia (Hz)
         frequencies = f_min:f_step:f_max; % Vector de frecuencias
         omega = 2 * pi * frequencies;    % Frecuencia angular
         
         ImpedanceM = A_red;
         for k1 = 1:length(Name)
            switch Name{k1}(1)
                case {'R', 'L', 'C','O','G','N'} % Passive elements
                    switch Name{k1}(1)
                        case 'R'
                            val = str2double(arg3{k1});  % Convertir el texto a número
                            comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                            syms(comp_name);  % Definir el símbolo
                            ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                        case 'L'
                            val = str2double(arg3{k1});  % Convertir el texto a número
                            comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                            syms(comp_name);  % Definir el símbolo
                            ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                        case 'C'
                            val = str2double(arg3{k1});  % Convertir el texto a número
                            comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                            syms(comp_name);  % Definir el símbolo
                            ImpedanceM = subs(ImpedanceM, sym(comp_name), val);
                    end
            end
        end
        
        % Inicializar una celda para almacenar los resultados
        results = cell(length(omega), 1);
        
        syms w;
        
        % Ciclo for para sustituir w por los valores definidos
        
        for i = 1:length(omega)
            % Sustituir w con el valor actual en la matriz A
            ImpedanceM = subs(ImpedanceM, w, omega(i));
            
            % Convertir el resultado a notación científica (con vpa)
            ImpedanceM_numeric = vpa(ImpedanceM); 
            
            % Guardar el resultado en la celda
            results{i} = ImpedanceM_numeric;
            
            % Mostrar el resultado actual en formato exponencial
            fprintf('Resultado para w = %e:\n', omega(i));
            % disp(ImpedanceM_numeric);
        end
        
        
        % Crear arreglos para almacenar los valores de Yij
        Y11 = zeros(length(omega), 1);
        Y12 = zeros(length(omega), 1);
        Y21 = zeros(length(omega), 1);
        Y22 = zeros(length(omega), 1);
        
        % Extraer los valores de las matrices de admitancia
        for i = 1:length(omega)
            % Obtener la matriz simbólica de cada celda
            Y_matrix = results{i};
            
            % Extraer valores complejos
            Y11(i) = Y_matrix(1, 1);
            Y12(i) = Y_matrix(1, 2);
            Y21(i) = Y_matrix(2, 1);
            Y22(i) = Y_matrix(2, 2);
        end



        end
    end
end