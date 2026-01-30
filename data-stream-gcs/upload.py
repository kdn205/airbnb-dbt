from google.cloud import storage
import io
import pandas as pd
from config import GCS_CONFIG


def upload_df_to_gcs(df: pd.DataFrame, table_name: str):
    client = storage.Client()  # dùng ADC từ gcloud
    bucket = client.bucket(GCS_CONFIG["bucket_name"])

    blob_path = f"{table_name}/{table_name}.csv"
    blob = bucket.blob(blob_path)

    buffer = io.StringIO()
    df.to_csv(buffer, index=False)

    blob.upload_from_string(
        buffer.getvalue(),
        content_type="text/csv"
    )

    print(f"Uploaded {table_name} → gs://{GCS_CONFIG['bucket_name']}/{blob_path}")
