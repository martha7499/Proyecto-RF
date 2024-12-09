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
        function obj=Y_to_Z(input)
                obj.dt=det(str2sym(input));%determinante
                n=2;
                obj.Zi=cell(n,n);%instanaciar la matriz
                %colocar valores en cada lugar de la matriz
                for x=1:n
                    for y=1:n
                        if (y==x)
                            obj.Zi{x,y}=obj.dt;
                        else
                            obj.Zi{x,y}=(-1*obj.dt);
                        end
                    end
                end
                %matriz determinada de z
                obj.Z=round(simplifyFraction(((str2sym(input))./obj.Zi)),4);
        end
         % Método para imprimir la matriz de celdas
        function displayZ(obj)
            disp('MATRIZ DE Z');
            disp(obj.Z);
        end
    end
end