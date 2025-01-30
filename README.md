

SOPS using AGE method and read password in AWS lambda function.

Step 1: Install Required Tools
Before starting, ensure you have the latest versions of:
✅ SOPS (for encrypting and decrypting secrets) <br />
✅ AWS CLI (for managing AWS resources)
✅ Terraform (for infrastructure as code)

Step 2: Project Files & Their Roles
           **File 1: main.tf **           Stores the username and password in AWS Secrets Manager from secrets.json. It also defines IAM roles and policies for the Lambda function.

           **File 2: data.tf**            Reads the encrypted file (secrets.enc.json) that is managed by SOPS.

           **File 3: .sops.yaml**         Defines rules for handling sensitive information and specifies which encryption keys to use.

           **File 4: secrets.enc.json**   Encrypted secrets file (contains sensitive information, encrypted using the AGE key).

           **File 5: secrets.dec.json**   Decrypted version of the secrets file, used for reference (not used in production).

           **File 6: secrets.json**       Stores username & password before encryption (this file should not be committed to version control).

           **File 7: Lambda_function.py** Retrieves the password from AWS Secrets Manager and checks for the existence of an environment variable, returning its value.



Step 3: Encrypt, Decrypt Secrets

✅age-keygen -o key.txt

✅sops --encrypt secrets.enc.json > secrets.json

✅sops --decrypt secrets.enc.json > secrets.dec.json



Step 4: Deploy & Run Lambda Function
This will:
✅ Store the encrypted secrets in AWS Secrets Manager
✅ Deploy the Lambda function with the necessary permissions

Summary
🔹 SOPS + AGE provides secure encryption for sensitive data.
🔹 Terraform automates the deployment of AWS resources.
🔹 AWS Secrets Manager securely stores and retrieves credentials for Lambda.

This setup ensures that passwords and sensitive data remain protected while allowing easy access for applications that need them. 🚀
