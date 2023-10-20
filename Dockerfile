# Docker file downloads all required dbt libraries
# Trigger and runs the pipeline script with all DBT commands
FROM python:3

ENTRYPOINT ["/bin/bash", "-l", "-c"]

ADD dbt_redshift /dbt_redshift

RUN pip install -U pip

# Install DBT libaries
RUN pip install --no-cache-dir dbt-core
RUN pip install --no-cache-dir dbt-redshift
RUN pip install --no-cache-dir boto3

WORKDIR /dbt_redshift
RUN chmod -R 755 .

CMD ["./run_dbt.sh"]
