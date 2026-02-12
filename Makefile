.PHONY: init plan apply destroy all

TF_DIR := terraform
TF := cd $(TF_DIR) && . ./openrc.sh && terraform
ANSIBLE_DIR := ansible

init:
	$(TF) init -upgrade

plan:
	$(TF) plan

apply:
	$(TF) apply -auto-approve

destroy:
	$(TF) destroy

all: init apply