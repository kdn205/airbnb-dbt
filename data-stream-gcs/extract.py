import psycopg2
import pandas as pd
from config import POSTGRES_CONFIG


def extract_table(table_name: str) -> pd.DataFrame:
    conn = psycopg2.connect(**POSTGRES_CONFIG)
    query = f"SELECT * FROM {table_name};"

    df = pd.read_sql(query, conn)
    conn.close()

    return df
