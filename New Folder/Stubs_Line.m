classdef Stubs_Line
    properties
        frequencie_work
        g
        ang_LE
        values
        N1
        N2
    end
    methods
        function obj=Stubs_Line(Arg5,k1,Arg3,Arg4,values,N1,N2)
            obj.N1=N1;
            obj.N2=N2;
            obj.values=values;
            %identificar en que frecuencia trabaja
            if contains(Arg5{k1},'G')
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+9);
            elseif contains(Arg5{k1},'M')
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+6);
            elseif contains(Arg5{k1},'K')
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+3);
            else
                disp("dato incorrecto");
            end
            obj.ang_LE=[deg2rad(str2sym(Arg4{k1}))];%pasar de grados a radianes
            %% para calcular ZL siempre con el valor mas a la derecha o 
            % mayor
            i=max(obj.N1(k1),obj.N2(k1));%encontrar el nodo
            g_line=str2sym('Lx');%identificar la variable a eleminar
            ZL=(str2sym(obj.values{i,i})-g_line);%tener los componentes de ZL
            Z0=str2sym(Arg3{k1});%pasar a simbolo para utilizarla en la ecuación
            j=str2sym('j');%utilizar en la ecuación
            w=str2sym('w');
            %% para calcular el valor de la linea
            obj.g=vpa(simplify(Z0*((ZL+(j*w*Z0*tan((obj.ang_LE)*(obj.frequencie_work/obj.frequencie_work))))/(Z0+(j*w*ZL*tan((obj.ang_LE)*(obj.frequencie_work/obj.frequencie_work)))))));
        end
    end
end
