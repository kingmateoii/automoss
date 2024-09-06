
import pymysql
import os
import sys
from dotenv import load_dotenv


def main():
    """Method to create/set database"""
    load_dotenv()

    DB_HOST = os.getenv('DB_HOST')

    MYSQL_ADMIN_USER = os.getenv('MYSQL_ADMIN_USER', 'root')
    MYSQL_ADMIN_PASSWORD = os.getenv('MYSQL_ADMIN_PASSWORD', 'password')
    DB_NAME = os.getenv('DB_NAME')
    DB_PORT = int(os.getenv('DB_PORT', 3306))  # Default to 3306 if not set

    try:
        # Create a connection object
       connection = pymysql.connect(
        host=DB_HOST,
        user=MYSQL_ADMIN_USER,
        password=MYSQL_ADMIN_PASSWORD,
        database=DB_NAME,  # Specify the database name
        port=DB_PORT,  # Specify the port number
        cursorclass=pymysql.cursors.DictCursor
    )
    except pymysql.err.OperationalError as e:
        print('Unable to connect to MYSQL as admin:', e)
        print('Please ensure that "MYSQL_ADMIN_USER" and "MYSQL_ADMIN_PASSWORD" are set correctly as environment variables.')
        exit(-1)

    DB_NAME = os.getenv('DB_NAME')
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')

    with connection:
        with connection.cursor() as cursor:
            cursor.execute(
                f"CREATE DATABASE IF NOT EXISTS {DB_NAME} CHARACTER SET utf8mb4;")

            cursor.execute(
                f"SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '{DB_USER}') AS E;")
            if not cursor.fetchone()['E']:
                # User does not exist
                cursor.execute(
                    f"CREATE USER IF NOT EXISTS '{DB_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '{DB_PASSWORD}';")
                cursor.execute(f"GRANT ALL ON {DB_NAME}.* TO '{DB_USER}'@'%';")
                cursor.execute('FLUSH PRIVILEGES;')


if __name__ == '__main__':
    main()
