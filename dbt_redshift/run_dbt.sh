#!/bin/bash

set -e

echo "Running python script to retreive redshift connection params"
python3 ./export_redshift_connection.py 

echo "Exporting Redshift credentials as environment variables to be used by dbt"
. ./.redshift_credentials

echo "Running DBT commands"
echo "Run all dependencies to collect the required packages before dbt model execution"
dbt deps --profiles-dir . --project-dir .

echo "Run seed operation to load static data to redshift"
dbt seed --profiles-dir . --project-dir .

echo "Run all model files holding business logic"
dbt run --profiles-dir . --project-dir .

echo "Run snapshot queries for SCD type2"
dbt snapshot --profiles-dir . --project-dir .

echo "Run all predefined test cases, Test cases can be configured to warn or error"
dbt test --profiles-dir . --project-dir .

echo "Generate documentation files"
dbt docs generate --profiles-dir . --project-dir .
echo ""

echo "Copying dbt documentation files for hosting"
aws s3 cp --recursive --exclude="*" --include="*.json" --include="*.html" dbt/target/ s3://<BucketName>/REDSHIFT_POC/
