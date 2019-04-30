# infra

## Setup

 - Uses local `gcloud` credentials
 - Expects local `.kube/config` to be authenticated to relevant clusters with `gcloud beta container clusters get-credentials` 
 - Run `make init-helm` to configure local Helm
 
## Terraform commands

 - Deploy using `make deploy-env env=$ENV`
 
 
## Secrets

 - Encrypt: `make encrypt-secret module=scrapyd secret=env env=prod`
 - Decrypt: `make decrypt-secret module=scrapyd secret=env env=prod`
    
## Notes

 - Assumes the bucket `tf-state.nightguide.app` exists
