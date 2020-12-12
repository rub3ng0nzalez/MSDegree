import numpy as np 
import pandas as pd

# Pivoteo individual de CSV indicado
def pivot_timeseries(archivo, nombre_columna_conteo='Conteo'):
    # Lectura y renombrado de columnas
    db = pd.read_csv(archivo)
    db.rename(columns = {'Province/State':'Estado', 'Country/Region': 'Pais', 'Lat':'Latitud', 'Long':'Longitud'}, inplace = True)

    # Rellenar estados nulos al nombre de su respectivo país
    db["Estado"].fillna(db["Pais"], inplace=True)
    db = db.set_index(['Pais', 'Estado', 'Latitud', 'Longitud'])

    # Pivotear tabla wide-to-long
    db = pd.melt(db.reset_index(), id_vars=['Pais', 'Estado', 'Latitud', 'Longitud'], value_vars = db.columns, var_name='Fecha', value_name=nombre_columna_conteo)
    db['Fecha'] = pd.to_datetime(db.Fecha)

    return db

# Fusión de CSVs en un solo dataframe
def merge_datasets():
    archivo_confirmados = 'time_series_covid19_confirmed_global.csv'
    archivo_recuperados = 'time_series_covid19_recovered_global.csv'
    archivo_fallecidos = 'time_series_covid19_deaths_global.csv'

    db_confirmados = pivot_timeseries(archivo_confirmados, 'Confirmados')

    db_final = pd.merge(db_confirmados,
                        pivot_timeseries(archivo_recuperados, 'Recuperados'),  
                        on =['Pais', 'Estado', 'Latitud', 'Longitud', 'Fecha'],
                        how ='left')
    db_final = pd.merge(db_final,
                        pivot_timeseries(archivo_fallecidos, 'Fallecidos'),  
                        on =['Pais', 'Estado', 'Latitud', 'Longitud', 'Fecha'],
                        how ='left')
  
    db_final = db_final.fillna(0)

    db_final = db_final.astype({"Confirmados": int, 
                                "Recuperados": int, 
                                "Fallecidos": int})
  
    return db_final