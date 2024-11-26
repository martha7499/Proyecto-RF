classdef Z_to_S
    properties
        S
    end
    methods
        function obj= Z_to_S(input,n)
            z0=cell(n,n);[z0{:}]=deal(50);%generar matriz de zo=50, para z normalizada
            zn=simplify(input./z0);%generar la z normalizada
            det1=((zn(1,1)+1)*(zn(2,2)+1))-(zn(1,2)*zn(2,1));%generar la determinada 1
            obj.S=cell(n,n);
            obj.S{1,1}=vpa(simplify(((zn(1,1)-1)*(zn(2,2)+1)-(zn(1,2)*zn(2,1)))/(det1)),4);
            obj.S{1,2}=vpa(simplify((2*zn(1,2))/(det1)),4);
            obj.S{2,1}=vpa(simplify((2*zn(2,1))/(det1)),4);
            obj.S{2,2}=vpa(simplify(((zn(1,1)+1)*(zn(2,2)-1)-(zn(1,2)*zn(2,1)))/(det1)),4);
        end 
        function displayS(obj)
            disp('MATRIZ DE S');
            disp(obj.S);
        end
    end

end
