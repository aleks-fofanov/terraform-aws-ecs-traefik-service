SHELL := /bin/bash

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md
export TERRAFORM_VERSION=0.12.19

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

## Lint terraform code
lint:
	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate

readme/sync: # Aka build with custom template
	README_TEMPLATE_FILE=$(shell pwd)/templates/README.md $(SELF) readme/build
