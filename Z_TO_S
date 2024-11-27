classdef Y_to_Z
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % transformada de valores y a z, en ella se genera cada termino de   %
     % manera indenpendiente y se guarda en su respectivo lugar de la     %
     % matriz z                                                           %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        Z %Matriz final de z
        Zi%Matriz para guardar los parametros en lo que se hace la divisio
        dt%Determinante de la matriz
    end
    methods
        function obj=Y_to_Z(input,n)
                obj.dt=det(str2sym(input));%determinante
                obj.Zi=cell(n,n);%instanaciar la matriz
                %colocar valores en cada lugar de la matriz
                obj.Zi{1,1}= obj.dt;
                obj.Zi{1,2}=(-1*obj.dt);
                obj.Zi{2,2}= obj.dt;
                obj.Zi{2,1}=(-1*obj.dt);
                %matriz determinada de z
                obj.Z=(simplify((str2sym(input))./obj.Zi));
        end
         % Método para imprimir la matriz de celdas
        function displayZ(obj)
            disp('MATRIZ DE Z');
            disp(obj.Z);
        end
    end
end
