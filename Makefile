REGION = eu-west-2
PYTHON_INTERPRETER = python3
WD=$(shell pwd)
PYTHONPATH=${WD}
SHELL := /bin/bash
PROFILE = default
PIP := pip

## Create python interpreter environment.
create-environment:
	@echo ">>> About to create environment: $(PROJECT_NAME)..."
	@echo ">>> check python3 version"
	( \
			$(PYTHON_INTERPRETER) --version; \
	)
	@echo ">>> Setting up VirtualEnv."
	( \
		$(PIP) install -q virtualenv virtualenvwrapper; \
		virtualenv venv --python=$(PYTHON_INTERPRETER); \
	)

# Define utility variable to help calling Python from the virtual environment
ACTIVATE_ENV := source venv/bin/activate

# Execute python related functionalities from within the project's environment
define execute_in_env
		$(ACTIVATE_ENV) && $1
endef

## Build the environment requirements
requirements: create-environment
	$(call execute_in_env, $(PIP) install -r ./requirements.txt)

generate:
	$(call execute_in_env, $(PYTHON_INTERPRETER) generate.py)

plan:
	cd terraform && terraform plan

apply: generate
	cd terraform && terraform apply

teardown: generate
	cd terraform && terraform destroy

fullrestore: generate
	cd terraform && terraform destroy
	cd terraform && terraform apply

list:
	aws lambda list-functions | jq .Functions[].FunctionName

invoke:
	aws lambda invoke --log-type Tail --function-name random-bucket /tmp/outgoing | jq .LogResult | tr -d '"' | base64 -d
	cat /tmp/outgoing
	@printf "\n\n"
	aws lambda invoke --log-type Tail --function-name random-zip /tmp/outgoing | jq .LogResult | tr -d '"' | base64 -d
	cat /tmp/outgoing
	@printf "\n\n"
	rm /tmp/outgoing