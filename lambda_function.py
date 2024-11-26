import os
import json
import boto3

def lambda_handler(event, context):
    # Retrieve secret from Secrets Manager
    secret_name = "my_secret"
    region_name = "eu-central-1"
    
    client = boto3.client('secretsmanager', region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    
    # Extract password
    password = secret.get("password", "No password found")
    
    specific_env_var_key = "MY_ENV_VAR"
    specific_env_var_value = os.environ.get(specific_env_var_key, "Not Found")
    
    # Return environment variables and password
    return {
        "password": password,
        "environment_variable": {specific_env_var_key: specific_env_var_value}
    }
