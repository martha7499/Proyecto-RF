classdef CellMatrixGenerator
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % funcion que genera una matriz de valores para el analisis númerico %
   % de los datos se utiliza la misma logica con que se genera G        %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
       % lines %tamaño de lineas
        Nm %Name
        N1 %Nodo 1
        N2 %Nodo 1
        Arg3 %Valores
        Arg4
        Arg5
        values %matriz de valores
    end
    
    methods
        % Constructor
        function obj = CellMatrixGenerator(input)
                [obj.Nm, obj.N1, obj.N2, obj.Arg3, obj.Arg4, Obj.Arg5] = input{:};
                lines=length(obj.Nm);
                obj.N1=str2double(obj.N1);   % Se guardan los valores de los nodos
                obj.N2=str2double(obj.N2);
                n = max([obj.N1; obj.N2]);
                obj.values =cell(n,n);
                for k1=1:lines
                    n1 = obj.N1(k1);   %se tienen dos variables de nodo
                    n2 = obj.N2(k1);
                    switch obj.Nm{k1}(1)
                        % elementos pasivo
                        case {'R', 'L', 'C'} % RXXXXXXX N1 N2 valor
                            switch obj.Nm{k1}(1)  %se forman los valores de inductancia.
                                case 'R'
                                    g=['1/' obj.Arg3{k1}];
                                case 'L'
                                    g=['1/s/' obj.Arg3{k1}];
                                case 'C'
                                    g=['s*' obj.Arg3{k1}];
                            end
                        % Aquí completamos la matriz G agregando conductancia.
                        % El procedimiento es ligeramente diferente si uno de los nodos está
                        % conectado a tierra, por lo que debe verificarlos según corresponda.
                            if (n1==0)
                                obj.values{n2,n2} = sprintf('%s + %s',obj.values{n2,n2},g);  % agrega la conductancia.
                            elseif (n2==0)
                                obj.values{n1,n1} = sprintf('%s + %s',obj.values{n1,n1},g);  % agrega la conductancia.
                            else
                                obj.values{n1,n1} = sprintf('%s + %s',obj.values{n1,n1},g);  % agrega la conductancia.
                                obj.values{n2,n2} = sprintf('%s + %s',obj.values{n2,n2},g);  % agrega la conductancia.
                                obj.values{n1,n2} = sprintf('%s - %s',obj.values{n1,n2},g);  % conducntancia negativa.
                                obj.values{n2,n1} = sprintf('%s - %s',obj.values{n2,n1},g);  % conductancia negativa.
                            end
                    end 
                end
        end
   
        % Método para imprimir la matriz de celdas
        function displayCellMatrix(obj)
            disp('Generated/Provided Cell Matrix:');
            disp(obj.values);
        end
    end
end
