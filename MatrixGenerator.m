%% Print out the netlist
function [Name,N1, N2, arg3, n, m, nLines, nPortM, G] = MatrixGenerator(fname);
    fprintf('Netlist:\n');
    %fname = "CircuitsExamples/nPortExample.cir";  % Modify with your file path
    fid = fopen(fname);
    fileIn = textscan(fid, '%s %s %s %s %s %s');
    [Name, N1, N2, arg3, arg4, arg5] = fileIn{:};
    fclose(fid);
    
    nLines = length(Name); 
    
    N1 = str2double(N1);   % Get node numbers
    N2 = str2double(N2);
    
    tic                  % Begin timing.
    
    n = max([N1; N2]);    % Number of nodes in the circuit
    
    m = 0; 
    for k1 = 1:nLines                 
        switch Name{k1}(1)
            case {'V', 'O', 'E', 'H'}  
                m = m + 1;             
        end
    end
    
    % Initializing matrices for the circuit components
    G = sym(zeros(n, n));  
    B = sym(zeros(n, m));
    C = sym(zeros(m, n));
    D = sym(zeros(m, m));
    i = sym(zeros(n, 1));
    e = sym(zeros(m, 1));
    j = sym(zeros(m, 1));
    v = sym('v_', [n, 1], 'real'); 
    
    vsCnt = 0;
    
    % Constructing G, B, C, D matrices for the circuit components
    for k1 = 1:nLines
        n1 = N1(k1);  
        n2 = N2(k1);
        
        switch Name{k1}(1)
            case {'R', 'L', 'C'} % Passive elements
                switch Name{k1}(1)
                    case 'R'
                        g = str2sym(['1/' Name{k1}]);
                    case 'L'
                        g = str2sym(['1/(1j*w*' Name{k1} ')']);
                    case 'C'
                        g = str2sym(['1j*w*' Name{k1}]);
                end
                if (n1 == 0)
                    G(n2, n2) = G(n2, n2) + g;  
                elseif (n2 == 0)
                    G(n1, n1) = G(n1, n1) + g;  
                else
                    G(n1, n1) = G(n1, n1) + g;
                    G(n2, n2) = G(n2, n2) + g;  
                    G(n1, n2) = G(n1, n2) - g;  
                    G(n2, n1) = G(n2, n1) - g;  
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
                e(vsCnt) = str2sym(Name{k1});         
                j(vsCnt) = str2sym(['I_' Name{k1}]);  
                
            case 'I' % Independent current source
                if n1 ~= 0
                    i(n1) = i(n1) - str2sym(Name{k1}); 
                end
                if n2 ~= 0
                    i(n2) = i(n2) + str2sym(Name{k1}); 
                end
        end
    end
    
    % Form the n-port A matrix
    A_n = [G, B; C, D];
    nPortM = G;
end
