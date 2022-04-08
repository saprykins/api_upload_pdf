FROM ubuntu:20.04

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install dependencies and pip requirements
COPY requirements.txt .
RUN apt-get update -q -y
RUN apt-get install -yf \
    gcc python-dev libkrb5-dev python3-docopt python3-gssapi \
    python3 \
    python3-pip
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt
RUN python3 -m spacy download en_core_web_sm

WORKDIR /app
COPY . /app

RUN useradd -ms /bin/bash user && chown -R user /app
USER user

EXPOSE 5000

ENTRYPOINT ["python3", "wsgi.py"]
