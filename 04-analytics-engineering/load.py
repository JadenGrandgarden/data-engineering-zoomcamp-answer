import os
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from google.cloud import storage
import time
import gzip
import pandas as pd


#Change this to your bucket name
BUCKET_NAME = "dezoomcamp_homework3_2025"  

#If you authenticated through the GCP SDK you can comment out these two lines
CREDENTIALS_FILE = "gcs.json"  
client = storage.Client.from_service_account_json(CREDENTIALS_FILE)

SERVICE_TYPE = "yellow"  # "green" or "yellow"
YEAR = 2020
BASE_URL = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{SERVICE_TYPE}/{SERVICE_TYPE}_tripdata_{YEAR}-"
# "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-"
# "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-"
# https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz
MONTHS = [f"{i:02d}" for i in range(1, 13)] 
DOWNLOAD_DIR = "./data/"

CHUNK_SIZE = 8 * 1024 * 1024  

os.makedirs(DOWNLOAD_DIR, exist_ok=True)

bucket = client.bucket(BUCKET_NAME)


def download_file(month):
    url = f"{BASE_URL}{month}.csv.gz"
    file_path = os.path.join(DOWNLOAD_DIR, f"{SERVICE_TYPE}_tripdata_{YEAR}-{month}.csv.gz")

    try:
        print(f"Downloading {url}...")
        urllib.request.urlretrieve(url, file_path)
        # Unzip the file .csv.gz to .csv file and remove the .csv.gz file
        with gzip.open(file_path, 'rb') as f_in:
            with open(file_path.replace('.gz', ''), 'wb') as f_out:
                f_out.writelines(f_in)
        os.remove(file_path)
        print(f"Downloaded: {file_path}")
        file_path = file_path.replace('.gz', '')
        return file_path
    except Exception as e:
        print(f"Failed to download {url}: {e}")
        return None


def verify_gcs_upload(blob_name):
    return storage.Blob(bucket=bucket, name=blob_name).exists(client)


def upload_to_gcs(file_path, max_retries=3):
    blob_name = os.path.basename(file_path)
    blob = bucket.blob(blob_name)
    blob.chunk_size = CHUNK_SIZE  
    
    for attempt in range(max_retries):
        try:
            print(f"Uploading {file_path} to {BUCKET_NAME} (Attempt {attempt + 1})...")
            blob.upload_from_filename(file_path)
            print(f"Uploaded: gs://{BUCKET_NAME}/{blob_name}")
            
            if verify_gcs_upload(blob_name):
                print(f"Verification successful for {blob_name}")
                return
            else:
                print(f"Verification failed for {blob_name}, retrying...")
        except Exception as e:
            print(f"Failed to upload {file_path} to GCS: {e}")
        
        time.sleep(5)  
    
    print(f"Giving up on {file_path} after {max_retries} attempts.")


if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=4) as executor:
        file_paths = list(executor.map(download_file, MONTHS))

    with ThreadPoolExecutor(max_workers=4) as executor:
        executor.map(upload_to_gcs, filter(None, file_paths))  # Remove None values

    print("All files processed and verified.")