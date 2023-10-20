import boto3
from botocore.exceptions import ClientError
import json
import os

secret_name = os.environ.get("secret_name")
region_name = os.environ.get("region_name")

# Create a Secrets Manager client
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)

try:
    get_secret_value_response = client.get_secret_value(
        SecretId=secret_name
    )
except ClientError as e:
    # For a list of exceptions thrown, see
    # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    raise e

# Decrypts secret using the associated KMS key.
secret = get_secret_value_response['SecretString']

db_secret = json.loads(secret)

dbhost = db_secret['host']
dbname = db_secret['dbClusterIdentifier']
username = db_secret['username']
password = db_secret['password']

host = dbhost.split(":")[0]


with open(".redshift_credentials",'w') as file:
    file.write(f"export DBT_REDSHIFT_HOST={host}")
    file.write("\n")
    file.write(f"export DBT_REDSHIFT_USER={username}")
    file.write("\n")
    file.write(f"export DBT_REDSHIFT_DB={dbname}")
    file.write("\n")
    file.write(f"export DBT_REDSHIFT_PASSWORD='{password}'")

file.close()