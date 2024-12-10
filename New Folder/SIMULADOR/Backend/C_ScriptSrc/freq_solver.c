/* #include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Prototipo para resolver el sistema A*x = z
void solveSystem(double* A, double* z, double* x, int n);

// Entrada principal
int main(int argc, char *argv[]) {
    if (argc < 5) {
        printf("Uso: %s freq_start freq_end freq_step output_file\n", argv[0]);
        return 1;
    }

    // Leer argumentos de línea de comandos
    double freq_start = atof(argv[1]);
    double freq_end = atof(argv[2]);
    double freq_step = atof(argv[3]);
    const char* output_file = argv[4];

    // Abrir archivo de salida
    FILE *fp = fopen(output_file, "w");
    if (!fp) {
        perror("Error al abrir archivo de salida");
        return 1;
    }

    // Definir el tamaño del sistema (nodos + fuentes)
    int n = 4; // Número de variables (ajusta según el circuito)
    double A[16] = {0}; // Matriz A (4x4 para este ejemplo, ajustar según tamaño)
    double z[4] = {0};  // Vector de entrada z
    double x[4] = {0};  // Vector solución x

    // Inicializar A y z (ejemplo, sustituir con datos reales)
    for (int i = 0; i < n * n; i++) A[i] = (i % (n + 1)) + 1; // Diagonal dominante
    for (int i = 0; i < n; i++) z[i] = 1.0;

    // Iterar sobre frecuencias
    for (double freq = freq_start; freq <= freq_end; freq += freq_step) {
        double w = 2 * M_PI * freq; // Convertir a rad/s

        // Modificar la matriz A y z según la frecuencia (ejemplo simplificado)
        A[0] = w; // Supongamos que depende de w
        z[0] = sin(w); // Otro ejemplo dependiente de w

        // Resolver el sistema A*x = z
        solveSystem(A, z, x, n);

        // Escribir la frecuencia y solución en el archivo
        fprintf(fp, "%.2f", freq);
        for (int i = 0; i < n; i++) {
            fprintf(fp, ", %.5f", x[i]);
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
    return 0;
}

// Función para resolver A*x = z (método de eliminación de Gauss)
void solveSystem(double* A, double* z, double* x, int n) {
    // Crear copias locales de A y z
    double a[n][n], b[n];
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i][j] = A[i * n + j];
        }
        b[i] = z[i];
    }

    // Eliminación de Gauss
    for (int i = 0; i < n; i++) {
        for (int k = i + 1; k < n; k++) {
            double factor = a[k][i] / a[i][i];
            for (int j = 0; j < n; j++) {
                a[k][j] -= factor * a[i][j];
            }
            b[k] -= factor * b[i];
        }
    }

    // Sustitución hacia atrás
    for (int i = n - 1; i >= 0; i--) {
        x[i] = b[i];
        for (int j = i + 1; j < n; j++) {
            x[i] -= a[i][j] * x[j];
        }
        x[i] /= a[i][i];
    }
}
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Prototipo para resolver el sistema A*x = z
void solveSystem(double* A, double* z, double* x, int n);


// Entrada principal
int main(int argc, char *argv[]) {
    if (argc < 6) {
        printf("Uso: %s freq_start freq_end freq_step output_file\n", argv[0]);
        return 1;
    }

    // Leer argumentos de línea de comandos
    double freq_start = atof(argv[1]);
    double freq_end = atof(argv[2]);
    double freq_step = atof(argv[3]);
    const char* output_file = argv[4];
    int n = atoi(argv[5]);

    // Abrir archivo de salida
    FILE *fp = fopen(output_file, "w");
    if (!fp) {
        perror("Error al abrir archivo de salida");
        return 1;
    }

    // Definir el tamaño del sistema (nodos + fuentes)
    double A[sizeof(n)] = {0}; // Matriz A (4x4 para este ejemplo, ajustar según tamaño)
    double z[sizeof(n)] = {0};  // Vector de entrada z
    double x[sizeof(n)] = {0};  // Vector solución x

    // Inicializar A y z (ejemplo, sustituir con datos reales)
    for (int i = 0; i < n * n; i++) A[i] = (i % (n + 1)) + 1; // Diagonal dominante
    for (int i = 0; i < n; i++) z[i] = 1.0;

    // Iterar sobre frecuencias
    for (double freq = freq_start; freq <= freq_end; freq += freq_step) {
        double w = 2 * M_PI * freq; // Convertir a rad/s

        // Actualizar A y z según la frecuencia (esto depende de tu circuito)
        // Aquí, por ejemplo, podemos usar una relación dependiente de frecuencia
        A[0] = w; // Dependencia simplificada de frecuencia para A
        z[0] = sin(w); // Dependencia simplificada de frecuencia para z

        // Resolver el sistema A*x = z
        solveSystem(A, z, x, n);

        // Escribir la frecuencia y solución en el archivo
        fprintf(fp, "%.2f", freq);
        for (int i = 0; i < n; i++) {
            fprintf(fp, ", %.5f", x[i]);
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
    return 0;
}

// Función para resolver A*x = z (método de eliminación de Gauss)
void solveSystem(double* A, double* z, double* x, int n) {
    // Crear copias locales de A y z
    double a[n][n], b[n];
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i][j] = A[i * n + j];
        }
        b[i] = z[i];
    }

    // Eliminación de Gauss
    for (int i = 0; i < n; i++) {
        for (int k = i + 1; k < n; k++) {
            double factor = a[k][i] / a[i][i];
            for (int j = 0; j < n; j++) {
                a[k][j] -= factor * a[i][j];
            }
            b[k] -= factor * b[i];
        }
    }

    // Sustitución hacia atrás
    for (int i = n - 1; i >= 0; i--) {
        x[i] = b[i];
        for (int j = i + 1; j < n; j++) {
            x[i] -= a[i][j] * x[j];
        }
        x[i] /= a[i][i];
    }
}
