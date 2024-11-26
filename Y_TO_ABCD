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
        function obj=Y_to_ABCD(input,n,dt)
            obj.abi=cell(n,n);
            obj.cdi=cell(n,n); [obj.cdi{:}]=deal(input{2,1});
            obj.abi{1,1}=(-1*(str2sym(input{2,2})));
            obj.abi{1,2}=-1;
            obj.abi{2,1}=(-1*dt);
            obj.abi{2,2}=(-1*(str2sym(input{1,1})));
            obj.ABCD=simplify(obj.abi./str2sym(obj.cdi));
        end 
          function displayABCD(obj)
            disp('MATRIZ DE ABCD');
            disp(obj.ABCD);
        end
    end
end
