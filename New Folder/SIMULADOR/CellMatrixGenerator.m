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
        %matriz de datos para stubs
        stubs_open 
        stubs_close
        stubs_line
        newC 
        n
        nPortM
        A_red
        A_n
        R
    end
    
    methods
        % Constructor
        function obj = CellMatrixGenerator(input,signal)
                [obj.Nm, obj.N1, obj.N2, obj.Arg3, obj.Arg4, obj.Arg5] = input{:};
                lines=length(obj.Nm);
                obj.N1=str2double(obj.N1);   % Se guardan los valores de los nodos
                obj.N2=str2double(obj.N2);
                obj.n = max([obj.N1; obj.N2]);
                obj.values =cell(obj.n,obj.n);
                k1_n=0;
                for k1=1:lines
                    n1 = obj.N1(k1);   %se tienen dos variables de nodo
                    n2 = obj.N2(k1);
                    switch obj.Nm{k1}(1)
                        % elementos pasivo
                        case {'R', 'L', 'C', 'O','G','N'} % RXXXXXXX N1 N2 valor
                            switch obj.Nm{k1}(1)  %se forman los valores de inductancia.
                                case 'R'
                                    g=['1/' obj.Arg3{k1}];
                                case 'L'
                                    g=['1/j*w' obj.Arg3{k1}];
                                case 'C'
                                    g=['j*w' obj.Arg3{k1}];
                                case 'O'  
                                    %Condicion para evualar en que rango de
                                    %frecuencia trabaja
                                    %signal1=signal;
                                    O=Stubs_Open(obj.Arg5,k1,obj.Arg4,obj.Arg3,signal);
                                    %g2=length(O.g);
                                    obj.stubs_open=O.g;
                                    %g=vpa(C.g{1,g2},4);
                                    g=vpa(O.g,4);
                                case 'G'
                                    %Condicion para evualar en que rango de
                                    %frecuencia trabaja                           
                                    G=Stubs_Close(obj.Arg5,k1,obj.Arg4,obj.Arg3,signal,G,obj.N1,obj.N2);
                                    %g2=length(C.g);
                                    obj.stubs_close=G.g;
                                    %g=vpa(C.g{1,g2},4);
                                    g=vpa(G.g,4);
                                case 'N'
                                    %se genera una variable para despues de
                                    %tener toda la lista de valores poder
                                    %sustituir correctamente el valor de la
                                    %linea
                                    g='Lx';%variable a sustituir
                                    k1_n=k1;%variable que se necesita 
                                    %para los datos dentro de la funcion
                                    %stubs_line
                            end
                            % Aquí completamos la matriz G agregando conductancia.
                            % El procedimiento es ligeramente diferente si uno de los nodos está
                            % conectado a tierra, por lo que debe verificarlos según corresponda.
                            if (n1==0)
                                obj.values{n2,n2} =sprintf('%s + %s',obj.values{n2,n2},g);  % agrega la conductancia.
                            elseif (n2==0)
                                obj.values{n1,n1} = sprintf('%s + %s',obj.values{n1,n1},g);  % agrega la conductancia.
                            else
                                obj.values{n1,n1} = sprintf('%s + %s',obj.values{n1,n1},g);  % agrega la conductancia.
                                obj.values{n2,n2} = sprintf('%s + %s',obj.values{n2,n2},g);  % agrega la conductancia.
                                obj.values{n1,n2} = sprintf('%s - %s',obj.values{n1,n2},g);  % conducntancia negativa.
                                obj.values{n2,n1} = sprintf('%s - %s',obj.values{n2,n1},g);  % conductancia negativa.
                            end
                               % Independent voltage source.
                            case 'V' % VXXXXXXX N1 N2 VALUE    (N1=anode, N2=cathode)
                                vsCnt = vsCnt + 1;  % Keep track of which source this is.
                                % Now fill in B and C arrays (again, process is slightly
                                % different if one of the nodes is ground).
                                if n1~=0
                                    B{n1,vsCnt} = [B{n1,vsCnt} ' + 1'];
                                    C{vsCnt, n1} = [C{vsCnt, n1} ' + 1'];
                                end
                                if n2~=0
                                    B{n2,vsCnt} = [B{n2,vsCnt} ' - 1'];
                                    C{vsCnt, n2} = [C{vsCnt, n2} ' - 1'];
                                end
                                e{vsCnt}=obj.Nm{k1};         % Add Name of source to RHS
                                j{vsCnt}=['I_' obj.Nm{k1}];  % Add current through source to unknowns
                                
                            % Independent current source
                            case 'I' % IXXXXXXX N1 N2 VALUE  (Current N1 to N2)
                                % Add current to nodes (if node is not ground)
                                if n1~=0
                                    i{n1} = [i{n1} ' - ' obj.Nm{k1}]; % subtract current from n1
                                end
                                if n2~=0
                                    i{n2} = [i{n2} ' + ' obj.Nm{k1}]; % add current to n2
                                end
                    end 
                end
                 for k1 = 1:nLines
                    n1 = N1(k1);
                    n2 = N2(k1);
                    switch obj.Nm{k1}(1)
                        case 'H'
                            cv = str2sym(obj.Arg3{k1});  
                            cvInd = find(j == cv);  
                            hInd = find(j == str2sym(obj.Nm{k1})); 
                            D(hInd, cvInd) = -str2sym(obj.Nm{k1});
                        case 'F'
                            cv = str2sym(arg3{k1}); 
                            cvInd = find(j == cv);  
                            if n1 ~= 0
                                B(n1, cvInd) = B(n1, cvInd) + str2sym(obj.Nm{k1});
                            end
                            if n2 ~= 0
                                B(n2, cvInd) = B(n2, cvInd) - str2sym(obj.Nm{k1});
                            end
                          end
                      end
                                
                    % Form the n-port A matrix
                    obj.A_n = [obj.values, B; C, D];
                    obj.nPortM = obj.values;
                    
                    fprintf('\nThe n-port A matrix (before reduction): \n');
                    disp(obj.A_n);
                    obj.A_red = obj.values;
                %funcion que una vez esta llena la matriz con valores
                %podemos hacer el calculo de la ZL
                if (k1_n==0)
                    celdas_vacias = cellfun(@isempty,A_red);
                    obj.values(celdas_vacias)={'0'};
                    obj.R=reducction_Kron(obj.n,obj.nPortM,obj.A_n,obj.values);
                else
                    N=Stubs_Line(obj.Arg5,k1_n,obj.Arg3,obj.Arg4,obj.values,obj.N1,obj.N2);
                    obj.stubs_line=N.g;
                    % Funcion para rellenar los espacios vacios con ceros en
                    % nodos que no tienen conexión entre si
                    celdas_vacias = cellfun(@isempty,obj.values);
                    obj.values(celdas_vacias)={'0'};                
                    % sustituir valores
                    obj.values=cellfun (@(x) str2sym(x), obj.values, 'UniformOutput',false);
                    obj.values=cellfun (@(x) subs(x,'Lx',obj.stubs_line),obj.values, 'UniformOutput', false);
                    obj.values=cellfun (@(x) char(x),obj.values, 'UniformOutput', false);
                    obj.R=reducction_Kron(obj.n,obj.nPortM,obj.A_n,obj.values);
                end
               
        end
   
        % Método para imprimir la matriz de celdas
        function displayCellMatrix(obj)
            disp('Generated/Provided Cell Matrix:');
            disp(obj.values);
        end
    end
end
