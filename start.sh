#!/bin/sh

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Start MySQL service
service mysql start

# Run Django server
python3 manage.py runserver $HOST_NAME:$PORT