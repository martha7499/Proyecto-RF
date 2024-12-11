clear
clc
close all

fileID = fopen('TouchStoneFiles/PB_Total.s2p', 'r');
frequencies=[];
S11_r=[];
S11_i=[];
S12_r=[];
S12_i=[];
S21_r=[];
S21_i=[];
S22_r=[];
S22_i=[];
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
        header = strsplit(line);
        continue;
    end
    
    % Leer datos numéricos
    [A,data] = sscanf(line, '%f');
    lenght_A=length(A);
    for j1=1:lenght_A
        if (j1==1)
            i=i+1;
            frequencies(i,1)=A(j1,1);
        elseif (j1==2)
            S11_r(i,1)=A(j1,1);
        elseif (j1==3)
            S11_i(i,1)=A(j1,1);
        elseif (j1==4)
            S12_r(i,1)=A(j1,1);
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
    S11=[];
    S11=complex(S11_r,S11_i);
    S12=[];
    S12=complex(S12_r,S12_i);
    S21=[];
    S21=complex(S21_r,S21_i);
    S22=[];
    S22=complex(S22_r,S22_i);
% Cerrar el archivo
fclose(fileID);

fprintf("ok");