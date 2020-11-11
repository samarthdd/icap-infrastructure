FROM python:3.7-stretch

WORKDIR /app
RUN apt-get update
RUN apt install c-icap -y
COPY ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
COPY . /app
CMD ["python", "main.py"]