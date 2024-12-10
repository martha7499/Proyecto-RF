classdef Stubs_Close
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % funcion que genera una matriz de valores para el analisis númerico %
   % de los datos de stubs close                                        %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        ang_LE %ángulo eléctrico 
        frequencie_work %frecuencía de trabajo
        g %matriz de valores
    end
    methods
        function obj=Stubs_Close(Arg5,k1,Arg4,Arg3,range_frequenci)
             if contains(Arg5{k1},'G')%conocer en que frecuencía trabaja
                obj.ang_LE=[deg2rad(str2sym(Arg4{k1}))];%pasar a radianes para la conversion
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+9);%multiplicar el valor de la frecuencia por su unidad
                obj.g=cell(1,length(range_frequenci));%generar la matriz para guardar los datos
                %for n=1:length(range_frequenci)%recorrer todas el analisis de frecuencias
                obj.g=vpa(simplify(((1/(Arg3{k1}))*(tan(obj.ang_LE*(obj.frequencie_work/obj.frequencie_work))))),4);%realizar la ecuación  
                %end
            elseif contains(Arg5{k1},'M')
                obj.ang_LE=[deg2rad(str2sym(Arg4{k1}))];%pasar a radianes para la conversion
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+6);%multiplicar el valor de la frecuencia por su unidad
                obj.g=cell(1,length(range_frequenci));%generar la matriz para guardar los datos
                %for n=1:length(range_frequenci)%recorrer todas el analisis de frecuencias
                obj.g=vpa(simplify(((1/(Arg3{k1}))*(tan(obj.ang_LE*(obj.frequencie_work/obj.frequencie_work))))),4);%realizar la ecuación  
                %end
            elseif contains(Arg5{k1},'K')
                obj.ang_LE=[deg2rad(str2sym(Arg4{k1}))];%pasar a radianes para la conversion
                obj.frequencie_work=((str2double(Arg5{k1}(1)))*1e+3);%multiplicar el valor de la frecuencia por su unidad
                obj.g=cell(1,length(range_frequenci));%generar la matriz para guardar los datos
                %for n=1:length(range_frequenci)%recorrer todas el analisis de frecuencias
                %obj.g{1,n}=vpa(simplify(((Arg3{k1})*(tan(obj.ang_LE*(range_frecuenci(n)/obj.frequencie_work))))),4);%realizar la ecuación  
                obj.g=vpa(simplify(((1/(Arg3{k1}))*(tan(obj.ang_LE*(obj.frequencie_work/obj.frequencie_work))))),4);
                %end 
            else
                disp("dato incorrecto");
             end
        end 
    end
end