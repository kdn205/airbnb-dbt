import os

POSTGRES_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "database": "airbnb-db",
    "user": "postgres",
    "password": os.getenv("PG_PASSWORD")
}

GCS_CONFIG = {
    "bucket_name": "airbnb-raw-bucket"
}

TABLES = [
    "hosts",
    "rooms",
    "locations",
    "pricing",
    # "review_stats"
]
