# Jupyter notebooks makefile
#
# https://swcarpentry.github.io/make-novice/reference.html
# https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# https://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

SHELL := /bin/bash
ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

CONDA_ENV_NAME = pytorch
CONDA_ENV_FULL_FILE = environment-full.yaml
CONDA_ENV_HIST_FILE = environment-hist.yaml

.DEFAULT_GOAL = notebook

.PHONY: notebook
notebook:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) \
		jupyter notebook \
			--IdentityProvider.token='' \
			--IdentityProvider.password_required='false' \
			--ServerApp.use_redirect_file=True \
			--ip=localhost \
			--port=8888 \
			--notebook-dir=$(ROOT)/notebooks

.PHONY: env-create
env-create:
	@conda env create --file $(CONDA_ENV_FULL_FILE)

.PHONY: env-update
env-update:
	@conda env update --file $(CONDA_ENV_FULL_FILE)

.PHONY: env-remove
env-remove:
	@conda env remove --name $(CONDA_ENV_NAME) --yes

.PHONY: env-init
env-init:
	@conda create --name $(CONDA_ENV_NAME) python=3.10.12

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda info

.PHONY: env-list
env-list:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda list

.PHONY: env-snapshot-history
env-snapshot-history:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda env export --from-history \
		| grep -v "^prefix: " > "$(CONDA_ENV_HIST_FILE)"

.PHONY: env-snapshot-full
env-snapshot-full:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda env export \
		| grep -v "^prefix: " > "$(CONDA_ENV_FULL_FILE)"

.PHONY: env-snapshot
env-snapshot: env-snapshot-history env-snapshot-full

.PHONY: clean-data
clean-data:
	@find . -name '*.gz' -type f -delete

.PHONY: clean-logs
clean-logs:
	@find . -name '*.log' -type f -delete

.PHONY: clean
clean: clean-logs clean-data
