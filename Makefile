SHELL := /bin/bash # Use bash syntax

define HELP_TEXT
Ubuntu.com website project
===

Usage:

> make setup        # Prepare dependencies
> make develop      # Run the dev server

endef

ENVPATH=${VIRTUAL_ENV}
VEX=vex --path ${ENVPATH}

ifeq ($(ENVPATH),)
	ENVPATH=env
endif

ifeq ($(PORT),)
	PORT=8011
endif

##
# Prepare the project
##
setup:
	# Create virtual env folder, if not already in one
	-[ -z ${VIRTUAL_ENV} ] && virtualenv ${ENVPATH}

	# Install requirements into virtual env
	${VEX} pip install -r requirements/dev.txt

develop:
	${VEX} python manage.py runserver_plus 0.0.0.0:${PORT}

rebuild-dependencies-cache:
	rm -rf pip-cache
	bzr branch lp:~webteam-backend/assets-manager/dependencies pip-cache
	pip install --exists-action=w --download pip-cache/ -r requirements.txt
	bzr commit pip-cache/ --unchanged -m 'automatically updated partners requirements'
	bzr push --directory pip-cache lp:~webteam-backend/assets-manager/dependencies
	rm -rf pip-cache src
