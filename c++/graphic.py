import pandas as pd
import matplotlib.pyplot as plt

# Cargar los datos desde el archivo CSV
data = pd.read_csv("execution_times.csv")

# Crear un boxplot para cada operación y tamaño
plt.figure(figsize=(12, 8))

# Generar un boxplot para cada operación (Insert, Search, Delete)
for operation in data['Operation'].unique():
    subset = data[data['Operation'] == operation]
    
    # Crear un boxplot para los tiempos en cada tamaño
    times_by_size = [subset[subset['Size'] == size]['Time'] for size in data['Size'].unique()]
    plt.boxplot(times_by_size, positions=range(len(times_by_size)), vert=True, patch_artist=True, 
                labels=data['Size'].unique(), notch=True, showmeans=True)
    
    # Personalizar el gráfico
    plt.title(f"Boxplot de Tiempos para la Operación: {operation}")
    plt.xlabel("Input Size")
    plt.ylabel("Execution Time (ns)")
    plt.yscale("log")  # Escala logarítmica para tiempos si hay gran variación
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Guardar y mostrar el gráfico
    plt.tight_layout()
    plt.savefig(f"{operation.lower()}_performance_boxplot.png")
    plt.show()
