WORKDIR := $(abspath .)
TERRAFORM := $(shell which tofu)
.DEFAULT_GOAL := apply

.PHONY: init apply refresh
.SILENT: init refresh
init:
	$(TERRAFORM) init

refresh:
	$(TERRAFORM) apply -refresh-only -auto-approve

apply: init refresh
	$(TERRAFORM) apply && $(TERRAFORM) apply -refresh-only -auto-approve

plan: init refresh
	$(TERRAFORM) plan

.PHONY: purge destroy
purge: destroy
	rm -rvf $(WORKDIR)/.terraform*
	rm -vf $(WORKDIR)/terraform.tfstate $(WORKDIR)/terraform.tfstate.backup

destroy:
	$(TERRAFORM) destroy
