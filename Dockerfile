FROM apache/airflow:2.1.3-python3.8
COPY requirements.txt .
RUN pip install -r requirements.txt && python -m spacy download en