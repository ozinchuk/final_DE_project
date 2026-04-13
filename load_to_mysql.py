import pandas as pd
from sqlalchemy import create_engine
import os


engine = create_engine('mysql+pymysql://root:root@localhost:53306/DE_final')


tables_to_load = {
    'customers': 'data/olist_customers_dataset.csv',
    'products': 'data/olist_products_dataset.csv',
    'orders': 'data/olist_orders_dataset.csv',
    'sellers': 'data/olist_sellers_dataset.csv'
}

for table_name, file_path in tables_to_load.items():
    if os.path.exists(file_path):
        df = pd.read_csv(file_path)
        df.to_sql(name=table_name, con=engine, if_exists='replace', index=False)
        print(f"{table_name} done")
    else:
        print(f"Error")
