function RectangularGraph(M11, M12, M21, M22, matrix, frequencies, option);
    % Graficar en carta rectangular
    % Graficar resultados
    if option == "MAG";
    
        figure;
        subplot(3, 2, 1);
        plot(frequencies, abs(M11), 'b', 'LineWidth', 1.5);
        title(sprintf('|%s_{11}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('|%s_{11}| (S)', matrix));
        grid on;
        
        subplot(3, 2, 2);
        plot(frequencies, abs(M12), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{12}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('|%s_{12}| (S)', matrix));
        grid on;
        
        subplot(3, 2, 3);
        plot(frequencies, abs(M21), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{21}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('|%s_{21}| (S)', matrix));
        grid on;
        
        subplot(3, 2, 4);
        plot(frequencies, abs(M22), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{22}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('|%s_{22}| (S)', matrix));
        grid on;
    else
        figure;
        subplot(3, 2, 1);
        plot(frequencies, 20*log(abs(M11)), 'b', 'LineWidth', 1.5);
        title(sprintf('|%s_{11}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('dB(%s_{11}) (S)', matrix));
        grid on;
        
        subplot(3, 2, 2);
        plot(frequencies, 20*log(abs(M12)), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{12}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('dB(%s_{12}) (S)', matrix));
        grid on;
        
        subplot(3, 2, 3);
        plot(frequencies, 20*log(abs(M21)), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{21}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('dB(%s_{21}) (S)', matrix));
        grid on;
        
        subplot(3, 2, 4);
        plot(frequencies, 20*log(abs(M22)), 'r', 'LineWidth', 1.5);
        title(sprintf('|%s_{22}| vs Frecuencia', matrix));
        xlabel('Frecuencia (Hz)');
        ylabel(sprintf('dB(%s_{22}) (S)', matrix));
        grid on;
    end
end