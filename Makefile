SHELL := /bin/bash

PROJECT_PREFIX = nightguide-app
ENVS = dev stg prod
KMS_ARGS=--location=global --keyring=$(module) --project=$(PROJECT_PREFIX)-$(env) --key=$(secret) --ciphertext-file=secrets/$(secret).$(env).enc --plaintext-file=-

# TODO: Create SA for current authenticated gcloud user and store it in deploy-key.json
#create-sa:
#	ACCOUNT=$(gcloud config list account --format "value(core.account)")
#	gcloud iam service-accounts keys create deploy-key.json --iam-account $(ACCOUNT)

init-helm:
	helm plugin install https://github.com/nouney/helm-gcs

deploy-env: _env-validate
	cd $(env); \
	helm repo add nightguide-app-$(env) gs://builds.nightguide.app/charts/$(env); \
	helm repo update; \
	terraform apply -var-file=vars.tfvars

encrypt-secret: _env-validate
	cd modules/$(module); \
	cat secrets/$(secret).$(env) | gcloud kms encrypt $(KMS_ARGS)

descrypt-secret: _env-validate
	cd modules/$(module); \
	gcloud kms decrypt $(KMS_ARGS) > secrets/$(secret).$(env)


_env-validate:
ifeq ($(filter $(env),$(ENVS)),)
	@echo "ERROR: env is required. supported: $(ENVS)"
	@exit 1
endif
