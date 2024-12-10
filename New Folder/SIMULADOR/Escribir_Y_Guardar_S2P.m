classdef Escribir_Y_Guardar_S2P
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modulo para guardar los datos y genere un archivo touchstone        %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        Range_frequencies
        S11
        S12
        S21
        S22
        T_frequency
        T_file
        Format
        fid
        filename
        filepath
        t1
    end
    
    methods
        % Constructor
        function obj = Escribir_Y_Guardar_S2P(Range_frequencies,S11,S12,S21,S22, T_frequency, T_file, format)
            %Instaciar las entradas del modulo con los parametros tipo
            %objeto que se guardaran
            if nargin > 0
                obj.Range_frequencies = Range_frequencies;
                obj.S11=S11;
                obj.S12=S12;
                obj.S21=S21;
                obj.S22=S22;
                obj.T_frequency = T_frequency;
                obj.T_file = T_file;
                obj.Format = format;
            end
        end
        % Metodo para escribir el archivo
        function filename=writeToFile(obj)
            obj.t1 = datestr(datetime('today'), 'dd-mmm-yyyy');%Fecha
            obj.filename = sprintf('file_%s.s2p', obj.t1);%genera el nombre del archivo
            obj.filepath = fullfile(pwd, obj.filename);
            obj.fid = fopen(obj.filepath, 'w');
            %obj.fid = fopen(obj.filename, 'w');%abre el archivo para escribir
            %cometario del archivo
            fprintf(obj.fid, '!File from Matlab\n');
            fprintf(obj.fid, '!Generated by Escribir_Y_Guardar_S2P class\n');
            %cabecera del archivo que determina caracteristicas
            fprintf(obj.fid, '# %s %s %s R 50\n', obj.T_frequency, obj.T_file, obj.Format);
            
            % Escribir cada parametros
            for i = 1:length(obj.Range_frequencies)
                %se tiene especificado la escritura de la parte real y la
                %imaginaria, ya que, fprintf no lo hace en automatico
                fprintf(obj.fid, '%.1f %.10f %.10f %.10f %.10f %.10f %.10f %.10f %.10f\n', obj.Range_frequencies(i,1),real(obj.S11(i,1)), imag(obj.S11(i,1)), real(obj.S12(i,1)), imag(obj.S12(i,1)),real(obj.S21(i,1)), imag(obj.S21(i,1)), real(obj.S22(i,1)), imag(obj.S22(i,1)));
            end
            %se cierra el archivo
            fclose(obj.fid);
            fprintf('File saved as %s\n', obj.filename);
            filename = obj.filename;
        end
    end
end
