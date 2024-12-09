classdef Netlist
    properties
        fid
        Name
        N1
        N2
        arg3
        arg4
        arg5
        fileIn
        G
        n
    end
    methods
        function obj=Netlist(input)
            type input
            obj.fid = fopen(input);
            obj.fileIn=textscan(obj.fid,'%s %s %s %s %s %s');  % lee el archivo genera 6 conceptos por linea
            % Genera 6 columnas por linea para dar lugar a los diferentes conceptos
            %El primer concepto es siempre el nombre del elemento del circuito, en el
            %segunod y tercer columna son los nodos del circuito, el cuarto valor es el
            % valor del elemento
            [obj.Name, obj.N1, obj.N2, obj.arg3, obj.arg4, obj.arg5] = obj.fileIn{:};
            %Elemento, nodo1, nodo2, y tres argumentos
            fclose(obj.fid);
            
            nLines = length(obj.Name);  %Numeros de lineas, significa el No. de elementos
            
            N1=str2double(obj.N1);   % Se guardan los valores de los nodos
            N2=str2double(obj.N2);
            
            tic                  % Se inicia el tiempo
            
            obj.n = max([N1; N2]);   % se busca el nodo mas grande 
            m=0; %m se le asignara el numero de fuentes de voltajes 
            for k1=1:nLines                  % Revisa todas las lineas para encontrar las fuentes de voltaje
                switch obj.Name{k1}(1)
                    case {'V', 'O', 'E', 'H'}  % casos dentro de las fuentes x las que se incrementa m
                        m = m + 1;             
                end
            end
            %% COLOCACION DE ARREGLO LITOVSKI NOTATION
            %Preasignacion de matrices para los elementos en la notacion de litovski
            %para la matriz A
            obj.G=cell(obj.n,obj.n);  [obj.G{:}]=deal('0');%inductancia% todas se rellenan con '0'
            B=cell(obj.n,m);  [B{:}]=deal('0');%ubicacion fuentes%Las dimensiones de cada matriz estan
            C=cell(m,obj.n);  [C{:}]=deal('0');%ubicacion fuentes%dadas  por la notacion
            D=cell(m,m);  [D{:}]=deal('0');%solo cero para fuentes independientes
            %para la matriz z
            i=cell(obj.n,1);  [i{:}]=deal('0');%valores de corriente atravez de elementos pasivos
            e=cell(m,1);  [e{:}]=deal('0');%valores de la fue
            % ntes 
            %para la matriz x
            j=cell(m,1);  [j{:}]=deal('0');%corrientes desconocidas de v
            v=compose('v_%d',(1:obj.n)');          %v es la matriz de fuentes
            
            % Registro de la cantidad de fuentes en el circuito
            % Inizalizamos la variable de las fuentes del circuito
            vsCnt = 0;
            
            % Este bucle realiza la mayor parte del llenado de las matrices.
            % Escanea línea por línea y llena las matrices según el tipo de
            % elemento que se encuentre en la línea actual.
            for k1=1:nLines
                n1 = N1(k1);   %se tienen dos variables de nodos
                n2 = N2(k1);
                
                switch obj.Name{k1}(1)
                    % elementos pasivos
                    case {'R','L','C','O','G','N'} % RXXXXXXX N1 N2 valor
                        switch obj.Name{k1}(1)  %se forman los valores de inductancia.
                            case 'R'
                                g=['1/' obj.Name{k1}];
                            case 'L'
                                g=['1/j/' obj.Name{k1}];
                            case 'C'
                                g=['j*' obj.Name{k1}];
                            case 'O'
                                g='Z0*1/(tan(Bd))';
                            case 'G'
                                g='Z0*tan(Bd)';
                            case 'N'
                                g='Z0*(ZL+jLZ0tan(Bd)/Z0+jZLtan(Bd))';
                                
                        end
                    % Aquí completamos la matriz G agregando conductancia.
                    % El procedimiento es ligeramente diferente si uno de los nodos está
                    % conectado a tierra, por lo que debe verificarlos según corresponda.
                        if (n1==0)
                            obj.G{n2,n2} = sprintf('%s + %s',obj.G{n2,n2},g);  % agrega la conductancia.
                        elseif (n2==0)
                            obj.G{n1,n1} = sprintf('%s + %s',obj.G{n1,n1},g);  % agrega la conductancia.
                        else
                            obj.G{n1,n1} = sprintf('%s + %s',obj.G{n1,n1},g);  % agrega la conductancia.
                            obj.G{n2,n2} = sprintf('%s + %s',obj.G{n2,n2},g);  % agrega la conductancia.
                            obj.G{n1,n2} = sprintf('%s - %s',obj.G{n1,n2},g);  % conducntancia negativa.
                            obj.G{n2,n1} = sprintf('%s - %s',obj.G{n2,n1},g);  % conductancia negativa.
                        end
                        
                    % fuentes de voltajes independientes.
                    case 'V' % VXXXXXXX N1 N2 valor   (N1=anodo, N2=catodo)
                        vsCnt = vsCnt + 1;  % Realice un seguimiento de cuál es esta fuente.
                        % Ahora complete las matrices B y C (nuevamente, el proceso es ligeramente
                        % diferente si uno de los nodos es tierra).
                        if n1~=0
                            B{n1,vsCnt} = [B{n1,vsCnt} ' + 1'];
                            C{vsCnt, n1} = [C{vsCnt, n1} ' + 1'];
                        end
                        if n2~=0
                            B{n2,vsCnt} = [B{n2,vsCnt} ' - 1'];
                            C{vsCnt, n2} = [C{vsCnt, n2} ' - 1'];
                        end
                        e{vsCnt}=obj.Name{k1};         % nombre de fuentes de voltaje
                        j{vsCnt}=['I_' obj.Name{k1}];  % agrega las fuentes de corriente desconocidas
                end 
            end
        end
    end
end