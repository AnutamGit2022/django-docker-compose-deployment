#base image
FROM python:3.9-alpine3.17

#Docker MAINTAINER command is specifically used to set the author details
LABEL maintainer="Anutam"

#The line "ENV PYTHONUNBUFFERED 1" in a Dockerfile sets an environment variable named "PYTHONUNBUFFERED" #
#to the value of "1" in the Docker container that will be built from the Dockerfile.
#The purpose of setting this environment variable is to disable the buffering of Python's standard output and standard error streams, 
#which can cause delays in the output of logs and other messages. 
#When Python is run with buffering enabled, it collects output in memory and only writes it to the console or file 
#once a certain amount of data has accumulated or the program completes. 
#Disabling this buffering ensures that output is immediately sent to the console or file as it is generate
ENV PYTHONUNBUFFERED 1

#The two lines "COPY ./requirements.txt /requirements.txt" and "COPY ./app /app" in a Dockerfile copy files from the host machine to the Docker container that will be built from the Dockerfile.
#The first line copies the file "requirements.txt" from the current directory (denoted by ".") on the host machine to the root directory ("/") in the container. 
#This file typically contains a list of dependencies required by the application or service being built in the container, such as Python packages or libraries.
#The second line copies the directory "app" from the current directory on the host machine to the directory "/app" in the container. 
#This directory typically contains the source code and other files required to run the application or service being built in the container.
COPY ./requirements.txt /requirements.txt
COPY ./app /app

#WORKDIR /app: This sets the working directory inside the container to /app, meaning that any subsequent commands will be run in that directory.
#EXPOSE 8000: This instruction exposes port 8000 to the host machine, allowing external connections to the container through that port.
WORKDIR /app
EXPOSE 8000

#This creates a Python virtual environment in the directory /py.
RUN python -m venv /py && \
    #'/py/bin/pip install --upgrade pip: This upgrades the version of pip inside the virtual environment.
    /py/bin/pip install --upgrade pip && \
    #'/py/bin/pip install -r /requirements.txt: This installs the Python dependencies listed in the file /requirements.txt.
    /py/bin/pip install -r /requirements.txt && \
    #'adduser --disabled-password --no-create-home app: This creates a new user named app without a password and without a home directory. This user will be used to run the application inside the container with reduced privileges.
    adduser --disabled-password --no-create-home app && \
#This Dockerfile instruction sets an environment variable named PATH inside the container.
#PATH="/scripts:/py/bin:$PATH": This sets the value of the PATH environment variable to include the directories /scripts and /py/bin, separated by colons, as well as any existing directories already in the PATH variable.
ENV PATH="/scripts:/py/bin:$PATH"
#This Dockerfile instruction sets the user that will be used to run subsequent commands in the container to app.
USER app