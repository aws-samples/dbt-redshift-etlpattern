# Docker file downloads all required dbt libraries
# Trigger and runs the pipeline script with all DBT commands
FROM python:3

ENTRYPOINT ["/bin/bash", "-l", "-c"]

ADD f1_dbt_poc /f1_dbt_poc

RUN pip install -U pip

# Install DBT libaries
RUN pip install --no-cache-dir dbt-core
RUN pip install --no-cache-dir dbt-redshift
RUN pip install --no-cache-dir boto3

WORKDIR /f1_dbt_poc
RUN chmod -R 755 .

CMD ["./run_dbt.sh"]
