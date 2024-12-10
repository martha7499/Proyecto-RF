classdef Matriz_values
    properties
        ImpedanceM
        ImpedanceM_Num
    end
    methods
        function obj=Matriz_values(Name,A_red,arg3,frequencies)
           omega = 2 * pi * frequencies;    % Frecuencia angular

            obj.ImpedanceM = A_red;
            for k1 = 1:nLines
    
                switch Name{k1}(1)
                    case {'R', 'L', 'C'} % Passive elements
                        switch Name{k1}(1)
                            case 'R'
                                val = str2double(arg3{k1});  % Convertir el texto a número
                                comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                syms(comp_name);  % Definir el símbolo
                                obj.ImpedanceM = subs(obj.ImpedanceM, sym(comp_name), val);
                                % disp(ImpedanceM);
                            case 'L'
                                val = str2double(arg3{k1});  % Convertir el texto a número
                                comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                syms(comp_name);  % Definir el símbolo
                                obj.ImpedanceM = subs(obj.ImpedanceM, sym(comp_name), val);
                                % disp(ImpedanceM);
                            case 'C'
                                val = str2double(arg3{k1});  % Convertir el texto a número
                                comp_name = matlab.lang.makeValidName(Name{k1});  % Asegurarse de que sea un nombre válido
                                syms(comp_name);  % Definir el símbolo
                                obj.ImpedanceM = subs(obj.ImpedanceM, sym(comp_name), val);
                                % disp(ImpedanceM);
                        end
                end
            end
            for i = 1:length(omega)
            % Sustituir w con el valor actual en la matriz A
                obj.ImpedanceM_Num = subs(obj.ImpedanceM, w, omega(i));
    
                % Convertir el resultado a notación científica (con vpa)
                obj.ImpedanceM_Num = vpa(obj.ImpedanceM_Num); 
    
                % Guardar el resultado en la celda
                %results{i} = ImpedanceM_Num;
    
                % Mostrar el resultado actual en formato exponencial
                % fprintf('Resultado para w = %e:\n', omega(i));
                % disp(ImpedanceM);
                % disp(ImpedanceM_Num);
              end
        end
    end
end
