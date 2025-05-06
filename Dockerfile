# syntax=docker/dockerfile:1
FROM python:3.11-slim

# Imposta variabili d'ambiente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Installa dipendenze di sistema necessarie
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
COPY . /opt
RUN pip3 install --upgrade pip
RUN pip3 install -e .
RUN pip3 install "design-django-theme==v1.4.8"

# let compose do this
# WORKDIR /django-project/
# RUN python3 manage.py migrate
# RUN python3 manage.py loaddata dumps/example.json
# ENTRYPOINT python3 manage.py runserver 0.0.0.0:8000
