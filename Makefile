##############################################################
#                                                            #
# AutoMOSS Makefile                                          #
#                                                            #
# Authors: Joshua Lochner, Daniel Lochner and Carl Combrinck #
# Date: 06/10/2021                                           #
#                                                            #
##############################################################

# Define variables
MAKE          := make
PYTHON        := python3

# Define directories
MEDIA_DIR     := media
COVERAGE_DIR  := htmlcov

# Define files
MAIN          := manage.py

install:
		# Ensure this line is indented with a tab
		sudo apt-get -y update
		# Ensure this line is indented with a tab
		sudo apt-get -y install redis mariadb-server libmariadb-dev python3-pip
		# Ensure this line is indented with a tab
		pip3 install -r requirements_dev.txt --upgrade
		# Ensure this line is indented with a tab
		$(MAKE) db

start-mysql:
		# Ensure this line is indented with a tab
		@[ "$(shell ps aux | grep mysqld | grep -v grep)" ] && echo "MariaDB already running" || (sudo service mariadb start)

run: start-mysql
		# Ensure this line is indented with a tab
		$(PYTHON) $(MAIN) runserver

migrations:
		# Ensure this line is indented with a tab
		$(PYTHON) $(MAIN) makemigrations && $(PYTHON) $(MAIN) migrate --run-syncdb

create-db:
		# Ensure this line is indented with a tab
		$(PYTHON) automoss/db.py

# https://simpleisbetterthancomplex.com/tutorial/2016/07/26/how-to-reset-migrations.html
db: start-mysql clean create-db migrations

docker-rebuild:
		# Ensure this line is indented with a tab
		docker-compose build
		# Ensure this line is indented with a tab
		$(MAKE) docker-start

docker-start:
		# Ensure this line is indented with a tab
		docker-compose up -d

docker-stop:
		# Ensure this line is indented with a tab
		docker-compose down

admin:
		# Ensure this line is indented with a tab
		$(PYTHON) $(MAIN) createsuperuser

clean-media:
		# Ensure this line is indented with a tab
		rm -rf $(MEDIA_DIR)/*

clean-redis:
		# Ensure this line is indented with a tab
		rm -f dump.rdb

clean-migrations:
		# Ensure this line is indented with a tab
		find . -path '*/migrations/*.py' -delete

clean:
		# Ensure this line is indented with a tab
		find . -type d -name __pycache__ -exec rm -r {} \+
		# Ensure this line is indented with a tab
		rm -rf $(COVERAGE_DIR)/*
		# Ensure this line is indented with a tab
		rm -rf .coverage

clean-all: clean-media clean-redis clean-migrations clean

test:
		# Ensure this line is indented with a tab
		export IS_TESTING=1 && $(PYTHON) $(MAIN) test -v 2

coverage:
		# Ensure this line is indented with a tab
		export IS_TESTING=1 && coverage run --source='.' $(MAIN) test -v 2
		# Ensure this line is indented with a tab
		coverage report
		# Ensure this line is indented with a tab
		coverage html
		# Ensure this line is indented with a tab
		$(PYTHON) -m webbrowser $(COVERAGE_DIR)/index.html

lint:
		# Ensure this line is indented with a tab
		flake8 . --statistics --ignore=E501,W503,F811
run:
		@echo "Starting the server on $(HOST_NAME):$(PORT)"
		python manage.py runserver $(HOST_NAME):$(PORT)