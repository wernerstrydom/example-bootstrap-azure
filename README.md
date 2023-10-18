# Bootstrap Azure

## Overview

This example shows how to bootstrap an Azure account with Terraform.  It performs the following:

1. Creates Azure AD Application and Service Principal
2. Creates Resource Group
3. Creates Azure Storage Account (where state is stored)
4. Updates GitHub Repository Secrets
5. Creates Documentation in Confluence 

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) >= 1.5
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.0.0
* A GitHub Repository for maintaining other repositories. You can create one with the following command replacing the values with your own:

    ```shell
    gh repo create myorg/devops --description "Repository to maintain other repositories in the organization" --add-readme --private
    ```
* A Confluence Space for maintaining documentation

## Usage

Create a file `terraform.tfvars` with the following content. Replace the values with your own:

```hcl
name     = "terraform"
location = "westus"

confluence_username="email@example.com"
confluence_token="ATATT3xqbcdefghjklmnopqrstuvwxyz"
confluence_site="example.atlassian.net"
confluence_space="DevOps"
github_owner = "wernerstrydom"
github_token = "ghp_abcdefghjklmnopqrstuvwxyz"
github_repository_name = "devops"
```

The values are as follows:

| Name                   | Description                                                                | Reference                                                                                                        |
|------------------------|----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| name                   | The name of the storage account, resource group and application            |                                                                                                                  |
| location               | The location of the storage account and resource group                     | [Azure Regions](https://azure.microsoft.com/en-us/global-infrastructure/locations/)                              |
| confluence_username    | The username of the Confluence user                                        |                                                                                                                  |
| confluence_token       | The API token of the Confluence user                                       | [Confluence API Tokens](https://confluence.atlassian.com/cloud/api-tokens-938839638.html)                        |
| confluence_site        | The site of the Confluence instance                                        |                                                                                                                  |
| confluence_space       | The space of the Confluence instance                                       |                                                                                                                  |
| github_owner           | The organization where repos are being stored                              |                                                                                                                  |
| github_token           | The API token of the GitHub user                                           | [GitHub API Tokens](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) |
| github_repository_name | The name of the repository responsible to manage GitHub, Azure and whatnot |                                                                                                                  |

For example, you could create a `devops` repository in your organization which would be reponsible for managing all the other repositories in your organization.  You can create it using the `gh` command line tool:

```shell
gh repo create myorg/devops --description "Repository to maintain other repositories in the organization" --add-readme --private
```

Before running Terraform apply, be sure to login to Azure.  You can do this with the following commands: 

```shell
az login
az account set --subscription <subscription_id>

terraform init
terraform plan
terraform apply
```

### Copy the State

Once the resources are created, you'll may need to copy the state to the storage account.  You can do this with the following command:

First, you'll need to add a backend configuration to your `terraform.tf` file, replacing the values with the ones generated:

```shell
terraform output -raw backend > backend.tf
```

Then, run the following commands:

```shell
terraform state push terraform.tfstate
```

You can now delete the local state file. 

> :note: You may want to remove the `backend.tf` file as well.

## Cleanup

If you'd like to delete the resources you just created, run the following command:

```shell
terraform destroy
```

## Contributing

```shell
terraform fmt -recursive
```

## License

This library is licensed under the MIT License. See the LICENSE file.
