FROM python:3.9-alpine3.17

LABEL maintainer="Anutam"

ENV PYTHONUNBUFFERED 1
ENV PATH="/scripts:/py/bin:$PATH"

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev linux-headers && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    chown -R app /app && \
    chmod -R 755 /app

USER app
