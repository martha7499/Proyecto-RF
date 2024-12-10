function SmithGraph(f_min, f_max, M11, M12, M21, M22, matrix);
    % % Graficar en la Carta de Smith
    frequenciesA = linspace(f_min, f_max, length(M11)); % Frecuencias igualmente espaciadas
    frequenciesB = linspace(f_min, f_max, length(M12)); % Frecuencias igualmente espaciadas
    frequenciesC = linspace(f_min, f_max, length(M21)); % Frecuencias igualmente espaciadas
    frequenciesD = linspace(f_min, f_max, length(M22)); % Frecuencias igualmente espaciadas
    % smithplot(frequencies, S11);
    
    
    figure;
    
    subplot(2, 2, 1);
    smithplot(frequenciesA, -M11);
    title(sprintf('%s(1,1)', matrix));
    grid on;
    
    subplot(2, 2, 2);
    smithplot(frequenciesB, -M12);
    title(sprintf('%s(1,2)', matrix));
    grid on;
    
    subplot(2, 2, 3);
    smithplot(frequenciesC, -M21);
    title(sprintf('%s(2,1)', matrix));
    grid on;
    
    subplot(2, 2, 4);
    smithplot(frequenciesD, -M22);
    title(sprintf('%s(2,2)', matrix));
    grid on;
    
    % Configuración general
    sgtitle('Gráfica de parámetros S en la Carta de Smith (1 GHz a 10 GHz)');
end