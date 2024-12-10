classdef Y_to_ABCD
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % transformada de valores y a ABCD, en ella se genera cada termino   %
     % de manera indenpendiente y se guarda en su respectivo lugar de la  %
     % matriz ABCD                                                        %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        abi%Matriz necesaria para guardar los datos
        cdi%Matriz necesaria para guardar los datos
        ABCD%Matriz final de ABCD
    end
    methods
        function obj=Y_to_ABCD(input,dt)
            n=2;
            obj.abi=cell(n,n);%indicar los datos
            %Generar matriz con valor de Y21 para la transformada
            obj.cdi=cell(n,n); [obj.cdi{:}]=deal(input{2,1});
            % reducción de las matrices para ajustarse de la matriz de nxn
            % a matrices de 2x2
            obj.cdi=obj.cdi(1:2, 1:2);
            reduced_y=input(1:2, 1:2);
            %Generer otra matriz para la divisicion con los elementos de
            %cada espacio 
            obj.abi{1,1}=(-1*(str2sym(reduced_y{2,2})));
            obj.abi{1,2}=-1;
            obj.abi{2,1}=(-1*dt);
            obj.abi{2,2}=(-1*(str2sym(reduced_y{1,1})));
            %Matriz final de ABCD
            obj.ABCD=round(simplify(obj.abi./str2sym(obj.cdi)),4);
        end 
        %función para desplejar los datos de la matriz ABCD
          function displayABCD(obj)
            disp('MATRIZ DE ABCD');
            disp(obj.ABCD);
        end
    end
end