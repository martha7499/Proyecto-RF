function RectangularGraph(M11, M12, M21, M22, matrix, frequencies);
    % Graficar en carta rectangular
    % Graficar resultados
    figure;
    subplot(3, 2, 1);
    plot(frequencies, abs(M11), 'b', 'LineWidth', 1.5);
    title(sprintf('|%s_{11}| vs Frecuencia', matrix));
    xlabel('Frecuencia (Hz)');
    ylabel('|matrix_{11}| (S)');
    grid on;
    
    subplot(3, 2, 2);
    plot(frequencies, abs(M12), 'r', 'LineWidth', 1.5);
    title(sprintf('|%s_{12}| vs Frecuencia', matrix));
    xlabel('Frecuencia (Hz)');
    ylabel('|matrix_{12}| (S)');
    grid on;
    
    subplot(3, 2, 3);
    plot(frequencies, abs(M21), 'r', 'LineWidth', 1.5);
    title(sprintf('|%s_{21}| vs Frecuencia', matrix));
    xlabel('Frecuencia (Hz)');
    ylabel('|matrix_{12}| (S)');
    grid on;
    
    subplot(3, 2, 4);
    plot(frequencies, abs(M22), 'r', 'LineWidth', 1.5);
    title(sprintf('|%s_{22}| vs Frecuencia', matrix));
    xlabel('Frecuencia (Hz)');
    ylabel('|matrix_{12}| (S)');
    grid on;
end