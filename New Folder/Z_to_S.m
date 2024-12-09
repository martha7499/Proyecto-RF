classdef Z_to_S
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % transformada de valores Z a S, en ella se genera cada termino      %
     % de manera indenpendiente y se guarda en su respectivo lugar de la  %
     % matriz S                                                           %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        S
    end
    methods
        function obj= Z_to_S(input)
            n=2;
            v_diag=zeros(n,1);
            v_diag(:)=50;
            z0= diag(v_diag);
            z1=(input+z0);
            z3=inv(z1);
            z2=(input-z0);
            obj.S=round(simplifyFraction((z3)*(z2)),4);
        end
        %funcion para generar la matriz
        function displayS(obj)
            disp('MATRIZ DE S');
            disp(obj.S);
        end
    end

end