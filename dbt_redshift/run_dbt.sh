#!/bin/bash

set -e

echo "Running .py script to get glue connection redshift credentials"
python3 ./export_redshift_connection.py 

echo "Exporting Redshift credentials as environment variables to be used by dbt"
. ./.redshift_credentials

echo "Running DBT commands"
echo "Execute all dependencies"
dbt deps --profiles-dir . --project-dir .

echo "Processing seed files to redshift"
dbt seed --profiles-dir . --project-dir .

echo "Execute all model files to redshift"
dbt run --profiles-dir . --project-dir .

echo "Execute snapshot tables queries"
dbt snapshot --profiles-dir . --project-dir .

echo "Run all predefined test cases"
dbt test --profiles-dir . --project-dir .

echo "Generate documentation"
dbt docs generate --profiles-dir . --project-dir .
echo ""

echo "Copying dbt outputs to s3 bucket fom-dev-martech-dbt-documentation for hosting"
aws s3 cp --recursive --exclude="*" --include="*.json" --include="*.html" dbt/target/ s3://<BucketName>/REDSHIFT_POC/