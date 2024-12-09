classdef S_to_T
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Funcionn para la transformada S a T que genera la matriz T final    %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        T %declaras la variable objeto
    end
    methods
        function obj=S_to_T(input)
            n=2;
            % declaras las matriz de celdas
            obj.T=cell(n,n);
            % declaras cada ecuacion o valor para cada variable de la
            % matriz
            for x=1:n
                for y=1:n
                    if (x==y)
                        obj.T{x,y}=(1-input(x,y));
                    else
                        obj.T{x,y}=(-1*input(x,y));
                    end
                end
            end
            % para sacar la determinante de la matriz
            dt=(det(vpa(input)));
            % evaluar la determinante sea zero
            if (dt~=0)
                obj.T=round((obj.T./dt),4);%generar la división
            else
                warning('El determinante de S es cero; normalización omitida');
            end
        end
        %funcion de desplegue
        function displayT(obj)
            disp('MATRIZ DE T');
            disp(obj.T);
        end
    end
end