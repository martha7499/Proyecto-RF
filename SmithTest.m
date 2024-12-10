% Ejemplo de datos
frequencies = linspace(1e9, 10e9, 100);  % Frecuencias de 1 GHz a 10 GHz
real_part = linspace(0.5, -0.3, 100);   % Parte real de S11
imag_part = linspace(0.2, -0.1, 100);   % Parte imaginaria de S11

% Construir el parámetro S11 como números complejos
S11 = complex(real_part, imag_part);  % También puedes usar real_part + 1j*imag_part

% Graficar en la Carta de Smith
smithplot(frequencies, S11, 'b-', 'LineWidth', 1.5);  % Línea azul
title('Gráfica de S_{11} en la Carta de Smith');
xlabel('Frecuencia [Hz]');
