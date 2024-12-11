% classdef S_to_T
%     properties
%         T
%     end
%     methods
%         function obj=S_to_T(input,n)
%             obj.T=cell(n,n);
%             dt=(-1*(det(vpa(input))));
%             obj.T{1,1}=vpa(dt/(input{2,1}),4);
%             obj.T{1,2}=vpa((input{1,1})/(input{2,1}),4);
%             obj.T{2,1}=vpa((-1*(input{2,2}))/input{2,1},4);
%             obj.T{2,2}=vpa(1/input{2,1},4);
%         end
%         function displayT(obj)
%             disp('MATRIZ DE T');
%             disp(obj.T);
%         end
%     end
% end

function T = S_to_T(S)
    S11 = S(1, 1);
    S12 = S(1, 2);
    S21 = S(2, 1);
    S22 = S(2, 2);

    % T11 = (1+S11)/(1-S11);
    % T12 = (2*S21)/(1-(S11*S22)+(S12*S21));
    % T21 = (2*S21)/(1-(S11*S22)+(S12*S21));
    % T22 = (1+S22)/(1-(S11*S22)+(S12*S21));

    T11 = (1./(S21));
    T12 = -(S22./S21);
    T21 = (S11./S21);
    T22 = -((S11*S22)-(S12*S21))./S21;

    T = [T11, T12; T21, T22];

    
    
    
    % fprintf("Matriz T\n");
    % disp(T);
end