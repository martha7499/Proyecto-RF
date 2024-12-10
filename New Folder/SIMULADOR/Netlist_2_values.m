classdef Netlist_2_values
    properties
        Name
        N1
        N2
        arg3
        arg4
        arg5
        fileIn
        G
        n
        A_red
        nLines
    end
    methods
        function obj=Netlist_2_values(input)
            %% Recognizing netlist in archive
            fprintf('\nStarting reading process ... please be patient.\n\n');

            % format short e;

            %% Print out the netlist
           fprintf('Netlist:\n');
           type input
           %fname =input;  % Modify with your file path
           fid = fopen(input);
           obj.fileIn = textscan(fid, '%s %s %s %s %s %s');
           [obj.Name, obj.N1, obj.N2, obj.arg3, obj.arg4, obj.arg5] = obj.fileIn{:};
           fclose(fid);

            obj.nLines = length(obj.Name); 
            
            obj.N1 = str2double(obj.N1);   % Get node numbers
            obj.N2 = str2double(obj.N2);
            
            tic                  % Begin timing.
            
            obj.n = max([obj.N1; obj.N2]);    % Number of nodes in the circuit
            
            m = 0; 
            for k1 = 1:obj.nLines                 
                switch obj.Name{k1}(1)
                    case {'V', 'O', 'E', 'H'}  
                        m = m + 1;             
                end
            end
            
            % Initializing matrices for the circuit components
            obj.G = sym(zeros(obj.n, obj.n));  
            B = sym(zeros(obj.n, m));
            C = sym(zeros(m, obj.n));
            D = sym(zeros(m, m));
            i = sym(zeros(obj.n, 1));
            e = sym(zeros(m, 1));
            j = sym(zeros(m, 1));
            v = sym('v_', [obj.n, 1], 'real'); 
            
            vsCnt = 0;
            
            % Constructing G, B, C, D matrices for the circuit components
            for k1 = 1:obj.nLines
                n1 = obj.N1(k1);  
                n2 = obj.N2(k1);
                
                switch obj.Name{k1}(1)
                    case {'R', 'L', 'C'} % Passive elements
                        switch obj.Name{k1}(1)
                            case 'R'
                                g = str2sym(['1/' obj.arg3{k1}]);
                            case 'L'
                                g = str2sym(['1/(1j*w*' obj.arg3{k1} ')']);
                            case 'C'
                                g = str2sym(['1j*w*' obj.arg3{k1}]);
                        end
                        if (n1 == 0)
                            obj.G(n2, n2) = obj.G(n2, n2) + g;  
                        elseif (n2 == 0)
                            obj.G(n1, n1) = obj.G(n1, n1) + g;  
                        else
                            obj.G(n1, n1) = obj.G(n1, n1) + g;
                            obj.G(n2, n2) = obj.G(n2, n2) + g;  
                            obj.G(n1, n2) = obj.G(n1, n2) - g;  
                            obj.G(n2, n1) = obj.G(n2, n1) - g;  
                        end
                        
                    case 'V' % Independent voltage source
                        vsCnt = vsCnt + 1;  
                        if n1 ~= 0
                            B(n1, vsCnt) = B(n1, vsCnt) + sym(1);         
                            C(vsCnt, n1) = C(vsCnt, n1) + sym(1);
                        end
                        if n2 ~= 0
                            B(n2, vsCnt) = B(n2, vsCnt) - sym(1);         
                            C(vsCnt, n2) = C(vsCnt, n2) - sym(1);
                        end
                        e(vsCnt) = str2sym(obj.Name{k1});         
                        j(vsCnt) = str2sym(['I_' obj.Name{k1}]);  
                        
                    case 'I' % Independent current source
                        if n1 ~= 0
                            i(n1) = i(n1) - str2sym(obj.Name{k1}); 
                        end
                        if n2 ~= 0
                            i(n2) = i(n2) + str2sym(obj.Name{k1}); 
                        end
                end
            end

            % Completing CCVS and CCCS elements
            for k1 = 1:obj.nLines
                n1 = obj.N1(k1);
                n2 = obj.N2(k1);
                switch obj.Name{k1}(1)
                    case 'H'
                        cv = str2sym(obj.arg3{k1});  
                        cvInd = find(j == cv);  
                        hInd = find(j == str2sym(obj.Name{k1})); 
                        D(hInd, cvInd) = -str2sym(obj.Name{k1});
                    case 'F'
                        cv = str2sym(obj.arg3{k1}); 
                        cvInd = find(j == cv);  
                        if n1 ~= 0
                            B(n1, cvInd) = B(n1, cvInd) + str2sym(obj.Name{k1});
                        end
                        if n2 ~= 0
                            B(n2, cvInd) = B(n2, cvInd) - str2sym(obj.Name{k1});
                        end
                end
            end

            % Form the n-port A matrix
            A_n = [obj.G, B; C, D];
            nPortM = obj.G;
            
            fprintf('\nThe n-port A matrix (before reduction): \n');
            disp(A_n);
            obj.A_red = obj.G;
            
            %% Reduction of the n-port network to a 2-port network using Kron
            
            if obj.n > 2
                fprintf('\nThe n-port A matrix (before reduction): \n');
                disp(A_n);
            
                % Partition the A_n matrix into internal and external nodes
                internal_nodes = 2:obj.n-1;  % Assuming nodes 3 to n are internal
                external_nodes = [1, obj.n];  % Ports
                
                % Submatrices
                A_ee = nPortM(external_nodes, external_nodes);  % External nodes
                A_ei = nPortM(external_nodes, internal_nodes); % External-Internal coupling
                A_ie = nPortM(internal_nodes, external_nodes); % Internal-External coupling
                A_ii = nPortM(internal_nodes, internal_nodes); % Internal nodes
                
                % Kron reduction
                obj.A_red = A_ee - A_ei * (A_ii \ A_ie);
                
                fprintf('\nThe reduced 2-port A matrix:\n');
                disp(obj.A_red);
                
                fprintf('\nElapsed time is %g seconds.\n', toc);
            else
                fprintf('\nThe 2-port matrix: \n');
                obj.A_red = obj.G;
                disp(obj.A_red);
            end
         end

     end
end