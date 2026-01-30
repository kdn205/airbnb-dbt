from extract import extract_table
from upload import upload_df_to_gcs
from config import TABLES


def run():
    for table in TABLES:
        print(f"Processing table: {table}")
        df = extract_table(table)
        upload_df_to_gcs(df, table)


if __name__ == "__main__":
    run()
