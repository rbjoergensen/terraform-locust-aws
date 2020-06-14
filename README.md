##### Terraform version
    Terraform v0.12.6
    + provider.aws v2.48.0

##### Dependencies
This project needs 
- ec2-keypair-terraform.ppk in its root directory
- tokens.csv in scripts folder containing tokens for authentication

Target Urls
- https://callofthevoid.dk

##### Initialize with keys for S3 backend
    terraform init \
        --var-file=variables.tfvars \
        --backend-config="access_key=<your access key>" \
        --backend-config="secret_key=<your secret key>"

##### Plan, Apply or Destroy
    terraform "<plan, apply, destroy>" \
        --var-file=variables.tfvars \
        --var="access_key=<secret>" \
        --var="secret_key=<secret>"
