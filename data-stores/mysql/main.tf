
#terraform {
#  backend "s3" {
#    # Replace this with your bucket name!
#    bucket = "terraform-up-and-running-state-eu-west-1-test-state-gtsvetkov"
#    key    = "stage/data-stores/mysql/terraform.tfstate"
#    region = "eu-west-1"
#
#    # Replace this with your DynamoDB table name!
#    dynamodb_table = "terraform-up-and-running-locks"
#    encrypt        = true
#  }
#}


provider "aws" { 
    region = "eu-west-1"
}

module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"
cluster_name           = "webservers-stage"
      db_remote_state_bucket = "terraform-up-and-running-state-eu-west-1-test-state-gtsvetkov"
      db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}


resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"

  # How should we set the password? You could use the AWS Secrets Manager UI to store the secret and then read the secret back out in your Terraform code using the aws_secretsman ager_secret_version data source:

  password = "1234567890" #data.aws_secretsmanager_secret_version.db_password.secret_string

}

# data "aws_secretsmanager_secret_version" "db_password" {
#      secret_id = "mysql-master-password-stage"
#}



#Here are some of the supported secret stores and data source combos that you might want to look into:
#• AWS Secrets Manager and the aws_secretsmanager_secret_version data source (shown in the preceding code)
#• AWS Systems Manager Parameter Store and the aws_ssm_parameter data source
#• AWS Key Management Service (AWS KMS) and the aws_kms_secrets data
#source
#• Google Cloud KMS and the google_kms_secret data source
#• Azure Key Vault and the azurerm_key_vault_secret data source
#• HashiCorp Vault and the vault_generic_secret data source

# The second option for handling secrets is to manage them completely outside of Ter‐ raform (e.g., in a password manager such as 1Password, LastPass, or OS X Keychain) and to pass the secret into Terraform via an environment variable. To do that, declare a variable called db_password in stage/data-stores/mysql/variables.tf:

#variable "db_password" {
#description = "The password for the database"
#type = string
#}


#As a reminder, for each input variable foo defined in your Terraform configurations, you can provide Terraform the value of this variable using the environment variable TF_VAR_foo. For the db_password input variable, here is how you can set the TF_VAR_db_password environment variable on Linux/Unix/OS X systems:
#    $  export TF_VAR_db_password="(YOUR_DB_PASSWORD)"
#    $ terraform apply

#An even better way to keep secrets from accidentally being stored on disk in plain text is to store them in a command-line–friendly secret store, such as pass, and to use a subshell to securely read the secret from pass and into an environment variable:
#    $ export TF_VAR_db_password=$(pass database-password)
#    $ terraform apply