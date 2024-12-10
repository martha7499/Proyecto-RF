function PolarGraph(M11, M12, M21, M22, matrix);
    % Graficar en forma polar
    figure; % Crear nueva ventana
    polarplot(angle(M11), abs(M11), 'b', 'LineWidth', 1.5); hold on;
    polarplot(angle(M12), abs(M12), 'r', 'LineWidth', 1.5);
    polarplot(angle(M21), abs(M21), 'g', 'LineWidth', 1.5);
    polarplot(angle(M22), abs(M22), 'm', 'LineWidth', 1.5);
    hold off;
    title(sprintf('Parámetros de %s: Forma Polar', matrix));
    % legend(sprintf({'%s_{11}', '%s_{12}', '%s_{21}', '%s_{22}'}, 'Location', 'Best', matrix));
end