# SOPS_using_AGE_method

SOPS using AGE method and read password in AWS lambda function.

Step1.  Installed latest Sops, Aws cli and terraform version version.

Step2. File 1: main.tf               (Stores username and password into the secret manager from secrets.json, IAM roles and policies for lambda function

           File 2: data.tf           (This data block accesses the encrypted file (secrets.enc.json) managed by SOPS)

           File 3: .sops.yaml        (outline a rule set for handling sensitive information)

           File 4: secrets.enc.json  (SOPS encrypts this file using Age key)

           File 5: secrets.dec.json  (serves as a reference for the unencrypted content)

           File 6: secrets.json       (username & password)

           File 7: Lambda_function.py (Retrieves a secret from AWS Secrets Manager and extracts the value of the password field. It also checks for the existence of a specific environment variable and returns its value)



Step 3: Encrypt, Decrypt using the following commands..

age-keygen -o key.txt

sops --encrypt secrets.enc.json > secrets.json

sops --decrypt secrets.enc.json > secrets.dec.json



Step 4: Run the lambda function in AWS after Terraform apply, you will able to see the output as a password field and environment variable)

