from airflow import DAG
from airflow.contrib.hooks.fs_hook import FSHook
from airflow.contrib.sensors.file_sensor import FileSensor
from airflow.hooks.mysql_hook import MySqlHook
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import os
#----librerias utiles para transformacion y carga
import numpy as np 
import pandas as pd


#--------Declaracion de variables globales
FILE_CONNECTION_ID = 'fs_default'
FILE_NAME_CONFIRMED = "time_series_covid19_confirmed_global.csv"
FILE_NAME_DEATHS = "time_series_covid19_deaths_global.csv"
FILE_NAME_RECOVERED = "time_series_covid19_recovered_global.csv"



#-----------Instancia de DAG
dag = DAG('Transformacion_data_dag', description='A new attempt to save a register',
          default_args={
              'depends_on_past': False,
              'max_active_runs': 1,
              'start_date': days_ago(2)
          },
          schedule_interval='0 1 * * *',
          catchup=False)
          

#-----Sensor para detectar archivo de casos confirmados          
file_sensor_task_confirmed = FileSensor(dag=dag,
                              task_id="file_sensor_confirmed",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME_CONFIRMED,
                              poke_interval=10,
                              timeout=300
                              )

#-----Sensor para detectar archivo de muertes        
file_sensor_task_deaths = FileSensor(dag=dag,
                              task_id="file_sensor_deaths",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME_DEATHS,
                              poke_interval=10,
                              timeout=300
                              )

#-----Sensor para detectar archivo de recuperados       
file_sensor_task_recovered = FileSensor(dag=dag,
                              task_id="file_sensor_recovered",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME_RECOVERED,
                              poke_interval=10,
                              timeout=300
                              )
 
 #---------Metodos necesarios para la transformacion
# Pivoteo individual de CSV indicado
def pivot_timeseries(archivo, nombre_columna_conteo='Conteo', **kwargs):
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
def merge_datasets(**kwargs):

    folder_path = FSHook(conn_id=FILE_CONNECTION_ID).get_path()
    
    archivo_confirmados = f"{folder_path}/{FILE_NAME_CONFIRMED}"
    archivo_recuperados = f"{folder_path}/{FILE_NAME_RECOVERED}"
    archivo_fallecidos = f"{folder_path}/{FILE_NAME_DEATHS}"

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
                                
                                
    os.remove(archivo_confirmados)
    os.remove(archivo_recuperados)
    os.remove(archivo_fallecidos)
    return db_final
 

# ------ Ejecutar transformacion    
transform_process = PythonOperator(dag=dag,
                                   task_id="transform_process",
                                   python_callable=merge_datasets,
                                   provide_context=True
                                   )





#----------------Insercion a base de datos                                   
def insert_process(**kwargs):
    ti = kwargs['ti']
    source_file = ti.xcom_pull(task_ids='transform_process')
    
    db_connection = MySqlHook('airflow_db').get_sqlalchemy_engine()
    df = source_file
    
    
    with db_connection.begin() as transaction:
        transaction.execute("TRUNCATE TABLE casos_covid")
        df.to_sql("casos_covid", con=transaction, schema="Mapamundi", if_exists="append",
                  index=False)


#--Interfaz de airflow
insert_process = PythonOperator(dag=dag,
                                task_id="insert_process",
                                provide_context=True,
                                python_callable=insert_process)
                                

#-----------Definicion del grafo
[file_sensor_task_confirmed, file_sensor_task_deaths, file_sensor_task_recovered] >> transform_process >> insert_process