# iac
## terraform
Not sure exactly why this is the case, but TF_VARS_access_key and TF_VARS_secret_key env vars work when using a local backend, but not with a remote s3 backend.
For that I need to use AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. 
Trying to use  TF_VARS_access_key and TF_VARS_secret_key env vars results in the error: 'Error configuring the backend "s3": No valid credential sources found for AWS Provider.'
