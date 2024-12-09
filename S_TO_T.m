classdef S_to_T
    properties
        T
    end
    methods
        function obj=S_to_T(input,n)
            obj.T=cell(n,n);
            dt=(-1*(det(vpa(input))));
            obj.T{1,1}=vpa(dt/(input{2,1}),4);
            obj.T{1,2}=vpa((input{1,1})/(input{2,1}),4);
            obj.T{2,1}=vpa((-1*(input{2,2}))/input{2,1},4);
            obj.T{2,2}=vpa(1/input{2,1},4);
        end
        function displayT(obj)
            disp('MATRIZ DE T');
            disp(obj.T);
        end
    end
end