from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'docker_compose_dag',
    default_args=default_args,
    description='A simple Docker Compose DAG',
    schedule_interval='@daily',
    start_date=days_ago(21),
    catchup=False,
) as dag:

    extract_task = DockerOperator(
        task_id='extract_task',
        image='Dockerfile_extract',
        api_version='auto',
        auto_remove=True,
        command='/bin/bash -c "python pull_data.py"',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        volumes=['/data:/data', '/output:/clean_data'],
    )

    transform_and_load_task = DockerOperator(
        task_id='transform_and_load_task',
        image='Dockerfile.transform_load',
        api_version='auto',
        auto_remove=True,
        command='/bin/bash -c "Rscript transform_load.R"',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        volumes=['/data:/data', '/output:/clean_data'],
    )

    extract_task >> transform_and_load_task
