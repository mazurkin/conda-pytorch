# Jupyter notebooks makefile
#
# https://swcarpentry.github.io/make-novice/reference.html
# https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# https://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

SHELL := /bin/bash
ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

NB_HOST         ?= localhost
NB_PORT_TBOARD  ?= 18887

CONDA_ENV_NAME   = jupyter

export PYTHONDONTWRITEBYTECODE = 1
export PYTHONUNBUFFERED        = 1

# -----------------------------------------------------------------------------
# notebook
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = tensorboard

.PHONY: tensorboard
tensorboard:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		tensorboard \
			--logdir "$(ROOT)/runs/" \
			--load_fast false \
			--host "$(NB_HOST)" \
			--port "$(NB_PORT_TBOARD)"
