from airflow import DAG
from airflow.contrib.hooks.fs_hook import FSHook
from airflow.contrib.sensors.file_sensor import FileSensor
from airflow.hooks.mysql_hook import MySqlHook
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import pandas as pd
import os
FILE_CONNECTION_ID = 'fs_default'
FILE_NAME = "sales.csv"
OUTPUT_TRANSFORM_FILE = '_sales_tmp.csv'
COLUMNS = {
    "ORDERNUMBER": "order_number",
    "QUANTITYORDERED": "quantity_ordered",
    "PRICEEACH": "price_each",
    "ORDERLINENUMBER": "order_line_number",
    "SALES": "sales",
    "ORDERDATE": "order_date",
    "STATUS": "status",
    "QTR_ID": "qtr_id",
    "MONTH_ID": "month_id",
    "YEAR_ID": "year_id",
    "PRODUCTLINE": "product_line",
    "MSRP": "msrp",
    "PRODUCTCODE": "product_code",
    "CUSTOMERNAME": "customer_name",
    "PHONE": "phone",
    "ADDRESSLINE1": "address_line_1",
    "ADDRESSLINE2": "address_line_2",
    "CITY": "city",
    "STATE": "state",
    "POSTALCODE": "postal_code",
    "COUNTRY": "country",
    "TERRITORY": "territory",
    "CONTACTLASTNAME": "contact_last_name",
    "CONTACTFIRSTNAME": "contact_first_name",
    "DEALSIZE": "deal_size"
}
dag = DAG('new_sales_dag', description='A new attempt to make the sales',
          default_args={
              'depends_on_past': False,
              'max_active_runs': 1,
              'start_date': days_ago(1)
          },
          schedule_interval='0 1 * * *',
          catchup=False)
file_sensor_task = FileSensor(dag=dag,
                              task_id="file_sensor",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME,
                              poke_interval=10,
                              timeout=300
                              )
def transform_func(**kwargs):
    folder_path = FSHook(conn_id=FILE_CONNECTION_ID).get_path()
    file_path = f"{folder_path}/{FILE_NAME}"
    destination_file = f"{folder_path}/{OUTPUT_TRANSFORM_FILE}"
    df = (pd.read_csv(file_path, header=0, names=COLUMNS.values(),
                      encoding="ISO-8859-1")
          .assign(order_date=lambda df: pd.to_datetime(df['order_date']))
          )
    df.to_csv(destination_file, index=False)
    os.remove(file_path)
    return destination_file
transform_process = PythonOperator(dag=dag,
                                   task_id="transform_process",
                                   python_callable=transform_func,
                                   provide_context=True
                                   )
def insert_process(**kwargs):
    ti = kwargs['ti']
    source_file = ti.xcom_pull(task_ids='transform_process')
    db_connection = MySqlHook('airflow_db').get_sqlalchemy_engine()
    df = pd.read_csv(source_file)
    with db_connection.begin() as transaction:
        transaction.execute("DELETE FROM test.sales WHERE 1=1")
        df.to_sql("sales", con=transaction, schema="test", if_exists="append",
                  index=False)
    os.remove(source_file)
insert_process = PythonOperator(dag=dag,
                                task_id="insert_process",
                                provide_context=True,
                                python_callable=insert_process)
file_sensor_task >> transform_process >> insert_process