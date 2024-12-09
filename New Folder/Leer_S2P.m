classdef Leer_S2P
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % función para leer los archivos S2P                                  %
    % aqui se generan matrices con valor de S11, S12, S21, S22 que guardan% 
    % cada valor real e imaginario de cada parametro en la frecuencia     %
    % se genrera tambien una matriz para guardar la frecuecia del         %
    % documento                                                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
       %declarar las variables objeto
        S11
        S12
        S21
        S22
        frequencies
        header
    end
    methods 
        function obj=Leer_S2P(input)
            %se abre y guarda documento s2p
            fileID = fopen(input, 'r');
            %Se les da un espacio a cada matriz
            obj.frequencies=[];
            %se generan dos matrices para cada termino para guradar la
            %parte real e imaginaria
            S11_r=[];
            S11_i=[];
            S12_r=[];
            S12_i=[];
            S21_r=[];
            S21_i=[];
            S22_r=[];
            S22_i=[];
            %se declara variable i para contador e indicar el llenado de
            %las matrices
            i=0;
            % Leer línea por línea
            while ~feof(fileID)%indica si se termino de leer todo el documento 
                line = fgetl(fileID); %debuelbe la primera linea del archivo
                
                % Ignorar comentarios o líneas vacías
                if startsWith(line, '!') || isempty(line)%evaluea si la primer línea empieza con ! o espacio en blanco
                    continue;
                end
                
                % Leer la línea de encabezado (si aplica)
                if startsWith(line, '#')
                    obj.header = strsplit(line);
                    continue;
                end
                
                % Leer datos numéricos
                %se genera matriz para que A guarde cada dato en una celda
                %de las columnas
                [A,data] = sscanf(line, '%f');
                lenght_A=length(A);%tamaño de A para generar el for
                for j1=1:lenght_A
                    %el primer valor de A es frecuencia por ende las
                    %condiciones
                    if (j1==1)
                        %i aumenta su valor y continaua con este hasta el final de for, hasta que se vulve a utilizar
                        i=i+1;
                        obj.frequencies(i,1)=A(j1,1);
                    elseif (j1==2)
                        S11_r(i,1)=A(j1,1);
                    elseif (j1==3)
                        S11_i(i,1)=A(j1,1);
                    elseif (j1==4)
                        S12_r(i,1)=A(j1,1);;
                    elseif (j1==5)
                        S12_i(i,1)=A(j1,1);
                    elseif (j1==6)
                        S21_r(i,1)=A(j1,1);
                    elseif (j1==7)
                        S21_i(i,1)=A(j1,1);
                    elseif (j1==8)
                        S22_r(i,1)=A(j1,1);
                    elseif (j1==9)
                        S22_i(i,1)=A(j1,1);
                    end
                end
            end
            %aquí se declara la matriz final de cada parametro que
            %contendra ambos valores de S
                obj.S11=[];
                obj.S11=complex(S11_r,S11_i);%funcion que guarda ambos valores en una sola celda
                obj.S12=[];
                obj.S12=complex(S12_r,S12_i);
                obj.S21=[];
                obj.S21=complex(S21_r,S21_i);
                obj.S22=[];
                obj.S22=complex(S22_r,S22_i);
            % Cerrar el archivo
            fclose(fileID);
        end
    end
end