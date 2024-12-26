FROM python:3.11.11-alpine3.21
WORKDIR /src
COPY src/requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /src/requirements.txt
COPY ./src /src
CMD ["uvicorn", "app:app", "--port", "80", "--proxy-headers"]