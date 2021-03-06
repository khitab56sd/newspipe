FROM python:3.8-alpine

RUN apk update && \
  apk add \
  build-base \
  curl \
  git \
  libffi-dev \
  openssl-dev \
  libxml2-dev \
  libxslt-dev \
  libpq \
  postgresql-client \
  postgresql-dev \
  npm

WORKDIR newspipe

COPY newspipe newspipe/
COPY instance instance/
COPY runserver.py .
COPY package.json .
COPY package-lock.json .
COPY pyproject.toml .
COPY poetry.lock .
COPY wait-for-postgres.sh .

RUN chmod +x ./wait-for-postgres.sh

RUN mkdir node_modules
RUN npm install
RUN mkdir -p newspipe/static/npm_components
RUN cp -R node_modules/* newspipe/static/npm_components/

RUN pip install poetry
RUN poetry install
