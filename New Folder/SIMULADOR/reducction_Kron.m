 classdef reducction_Kron
    properties
        A_red
    end
    methods
        function obj=reduction_Kron(n,nPortM,A_n,G)
        if n > 2
            fprintf('\nThe n-port A matrix (before reduction): \n');
            disp(A_n);
        
            % Partition the A_n matrix into internal and external nodes
            internal_nodes = 2:n-1;  % Assuming nodes 3 to n are internal
            external_nodes = [1, n];  % Ports
            
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
            A_red = G;
            disp(A_red);
        end
       end       
    end
end