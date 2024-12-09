clear
close all
clc

%% Recognizing netlist in archive
fprintf('\nStarting reading process ... please be patient.\n\n');

%% Print out the netlist
fprintf('Netlist:');
fname = "CircuitsExamples/example3.cir";  % Modify with your file path
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
                    g = str2sym(['1/(jw*' Name{k1} ')']);
                case 'C'
                    g = str2sym(['jw*' Name{k1}]);
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

% Completing CCVS and CCCS elements
for k1 = 1:nLines
    n1 = N1(k1);
    n2 = N2(k1);
    switch Name{k1}(1)
        case 'H'
            cv = str2sym(arg3{k1});  
            cvInd = find(j == cv);  
            hInd = find(j == str2sym(Name{k1})); 
            D(hInd, cvInd) = -str2sym(Name{k1});
        case 'F'
            cv = str2sym(arg3{k1}); 
            cvInd = find(j == cv);  
            if n1 ~= 0
                B(n1, cvInd) = B(n1, cvInd) + str2sym(Name{k1});
            end
            if n2 ~= 0
                B(n2, cvInd) = B(n2, cvInd) - str2sym(Name{k1});
            end
    end
end

% Form the n-port A matrix
A_n = [G, B; C, D];

% Display the n-port network matrix
fprintf('\nThe n-port A matrix (before reduction): \n');
disp(A_n);

% Now, let's reduce the n-port network to a 2-port network.
% Extracting relevant submatrices.
G2 = G(1:2, 1:2);
B2 = B(1:2, :);
C2 = C(:, 1:2);
D2 = D(:, :);

% Form the A matrix for the 2-port network
A2 = [G2, B2; C2, D2];

% Display the 2-port network matrix
fprintf('\nThe 2-port A matrix (after reduction): \n');
disp(A2);

% Solve the system for the 2-port network
x2 = [v(1:2); j(1:m)];  % Adjusted for 2-port system
z2 = [i(1:2); e];       % Adjusted for 2-port system

% Display the matrix equation for the 2-port system
fprintf('\nThe matrix equation for 2-port: \n');
disp(A2 * x2 == z2);

% Solve for the unknowns in the 2-port system
a2 = simplify(A2 \ z2);

% Display the solution for the 2-port network
fprintf('\nThe solution for the 2-port network: \n');
disp(x2 == a2);

%% Display elapsed time
fprintf('\nElapsed time is %g seconds.\n', toc);
