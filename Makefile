# Pytorch environment makefile
#
# https://swcarpentry.github.io/make-novice/reference.html
# https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# https://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

SHELL := /bin/bash
ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

NB_HOST         ?= localhost
NB_PORT_JUPYTER ?= 18888
NB_PORT_TBOARD  ?= 16006

CONDA_ENV_NAME = pytorch

# -----------------------------------------------------------------------------
# notebook
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = notebook

.PHONY: notebook
notebook:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) \
		jupyter notebook \
			--ServerApp.use_redirect_file True \
			--ip "$(NB_HOST)" \
			--port $(NB_PORT_JUPYTER) \
			--notebook-dir "$(ROOT)/notebooks"

.PHONY: notebook-setup-password
notebook-setup-password:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) \
		jupyter notebook password

.PHONY: notebook-setup-local
notebook-setup-local:
	@cp "$(ROOT)/misc/jupyter_server_config_local.json" "${HOME}/.jupyter/jupyter_server_config.json"

# -----------------------------------------------------------------------------
# conda environment
# -----------------------------------------------------------------------------

.PHONY: env-init
env-init:
	@conda create --yes --name $(CONDA_ENV_NAME) \
		python=3.10.12 \
		nvidia::cuda-toolkit=12.4.1 \
		conda-forge::cudnn=9.3.0.75 \
		conda-forge::poetry=1.8.3

.PHONY: env-create
env-create:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry install --no-root --no-directory

.PHONY: env-update
env-update:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry update

.PHONY: env-list
env-list:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry show

.PHONY: env-remove
env-remove:
	@conda env remove --yes --name $(CONDA_ENV_NAME)

.PHONY: env-shell
env-shell:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) bash

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda info

# -----------------------------------------------------------------------------
# util
# -----------------------------------------------------------------------------

.PHONY: clean-data
clean-data:
	@find . -name '*.gz' -type f -delete

.PHONY: clean-logs
clean-logs:
	@find . -name '*.log' -type f -delete

.PHONY: clean
clean: clean-logs clean-data

# -----------------------------------------------------------------------------
# tensorboard
# -----------------------------------------------------------------------------

.PHONY: tensorboard
tensorboard:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) \
		tensorboard \
			--logdir "$(ROOT)/notebooks/tensorboard" \
			--samples_per_plugin "images=1024,scalars=8096" \
			--host "$(NB_HOST)" \
			--port "$(NB_PORT_TBOARD)"

.PHONY: tensorboard-clean
tensorboard-clean:
	@rm -rf "$(ROOT)/notebooks/tensorboard/"
