#!/bin/sh

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Print environment variables for debugging
echo "HOST_NAME: $HOST_NAME"
echo "PORT: $PORT"

# Start MySQL service
service mysql start

# Run Django server
python3 manage.py runserver $HOST_NAME:$PORT