# Deploying DNS Delegated Subdomains using Terraform Cloud

## Introduction

When working on an application that is running in multiple clouds, the differences in default behaviour for DNS names of resources created in those clouds becomes clearer. When working with infrastructure as code, it becomes abundantly clear you need to have a predictable way to assign your resources DNS names.

The best practice is to deploy a dedicated DNS delegated subdomain into each cloud provider that you will be using for your application.

This blog post is going to show you how this could be done using Terraform Cloud. If you have a [Terraform Enterprise](https://www.terraform.io/docs/enterprise/index.html) installation in your company, you could use exactly the same configuration and setup to deploy this example from there. The reason for this is that Terraform Enterprise is deployed using the same engine that is used within Terraform Cloud.

The git repository for this blog post can be found here: 
[https://github.com/lhaig/dns-multicloud](https://github.com/lhaig/dns-multicloud)

You can read more about Terraform Enterprise here:

[https://www.terraform.io/docs/enterprise/index.html](https://www.terraform.io/docs/enterprise/index.html)

You can read more about Terraform Cloud here:

[https://www.terraform.io/docs/cloud/index.html](https://www.terraform.io/docs/cloud/index.html)

## Use this repository as a module

If you want to use the repository as a module you can use the [v1.1](https://github.com/lhaig/dns-multicloud/tree/v1.1) release and include it in the source block.
Example:

    module "dns-multicloud" {
      source              = "git::https://github.com/lhaig/dns-multicloud.git?ref=v1.1"
    }

## What is a Delegated Subdomain

In basic terms, a delegated DNS subdomain is a child domain of a larger parent domain name. It is used to organise web addresses. For example, mydomain.com is the parent domain and aws.mydomain.com is a child / subdomain.

In general, creating these in one environment is easy as the authoritative DNS servers are the same for the primary and the secondary zones. When you want to use these in different cloud providers for referencing resources within those providers, the providers need to have control of the domain. Therefore, we need to provision the zone on the DNS servers provided by the cloud providers. This is called delegating the zone.

## What you need

Accounts on the following cloud providers:

* AWS

* Azure

* GCP

Create a free account on the Terraform Cloud platform. You can find the signup page [here.](https://app.terraform.io/signup/account)

Login to your Terraform Cloud account.

![](https://cdn-images-1.medium.com/max/2000/1*TFR5y2WqF-xoToVodTP2Yw.png)

*If you are using the Terraform Cloud platform for the first time, you need to [create an organization](https://www.terraform.io/docs/cloud/users-teams-organizations/organizations.html) before creating the workspace needed.*
[Create a workspace](https://www.terraform.io/docs/cloud/workspaces/creating.html) to deploy your zones with.

Fork the [https://github.com/lhaig/dns-multicloud.git](https://github.com/lhaig/dns-multicloud.git) GitHub repository so that you can make changes to the plan for your deployment. We will link the repository to your workspace at the end of the blog post.

Now clone the git repository,

    git clone https://github.com/YOURNAME/dns-multicloud.git
    cd dns-multicloud

Open the file [variables.tf](https://github.com/lhaig/dns-multicloud/blob/master/variables.tf) in your editor. It will look like this:

    # General
    variable "owner" {
      description = "Person Deploying this Stack e.g. john-doe"
    }

    variable "namespace" {
      description = "Name of the zone e.g. demo"
    }

    variable "created-by" {
      description = "Tag used to identify resources created programmatically by Terraform"
      default     = "terraform"
    }

    variable "hosted-zone" {
      description = "The name of the dns zone on Route 53 that will be used as the master zone "
    }

    # AWS

    variable "create_aws_dns_zone" {
      description = "Set to true if you want to deploy the AWS delegated zone."
      type        = bool
      default     = "false"
    }

    variable "aws_region" {
      description = "The region to create resources."
      default     = "eu-west-2"
    }

    # Azure

    variable "create_azure_dns_zone" {
      description = "Set to true if you want to deploy the Azure delegated zone."
      type        = bool
      default     = "false"
    }

    variable "azure_location" {
      description = "The azure location to deploy the DNS service"
      default     = "West Europe"
    }

    # GCP

    variable "create_gcp_dns_zone" {
      description = "Set to true if you want to deploy the Azure delegated zone."
      type        = bool
      default     = "false"
    }

    variable "gcp_project" {
      description = "GCP project name"
    }

    variable "gcp_region" {
      description = "GCP region, e.g. us-east1"
      default     = "europe-west3"
    }

Now open the workspace [Variables](https://www.terraform.io/docs/cloud/workspaces/variables.html) section in the workspace and create and populate the variables as they are listed above. The result should look like this:

![Standard Terraform Variables](https://cdn-images-1.medium.com/max/4768/1*_lVrCnMCUR-BpUvfvBe3kA.png)*Standard Terraform Variables*

Next, you will need to create the [Environment Variables](https://www.terraform.io/docs/cloud/workspaces/variables.html#environment-variables) with the authentication credentials for each cloud provider.

The Environment Variables should all be created and marked as [sensitive](https://www.terraform.io/docs/cloud/workspaces/variables.html#sensitive-values). They should look like this once you have finished.

![Environment Variables](https://cdn-images-1.medium.com/max/2438/1*ZESW7paEdHNbz0XKogDqpA.png)*Environment Variables*

Terraform Cloud does not allow new line characters in variables and so needs to have the GOOGLE_CREDENTIALS as a specific format, as the standard way they are provided is via a json file.

Follow the steps below to prepare them.

    vim gcp-credentials.json
    
    then press :
    
    enter the following 
    %s;\n; ;g
    
    Press enter
    
    Save the file by pressing : then wq and press enter

If you do not have access to vim in your environment. Open the editor of your choice and remove all Carriage returns from the file so the complete json file is on one line.

Copy the contents of the file into the variable, mark it as sensitive, and Save.

## Add the Git repository to your Workspace

To automate the deployment of this repository, we need to connect the git repository to your workspace in Terraform Cloud. To do this, access the workspace settings and select the version control section.

![](https://cdn-images-1.medium.com/max/2000/1*5ROao9CdQpzTGRlN9cQ9rg.png)

Once you select it, you will be presented with the version control page. Terraform Cloud supports a number of VCS providers.

Open the [Terraform VCS](https://www.terraform.io/docs/cloud/vcs/) page to find out how to connect your specific provider to your organization. Once the provider is connected, follow on from here.

We will use GitHub as the provider but the workflow will be similar for other providers. Click on the Connect to Version Control button** **on the page. Select the **Github** button.

![](https://cdn-images-1.medium.com/max/2852/1*CJ8BOCalFaLScBVApdWymg.png)

Select your organization in the dropdown. Find the cloned repository **dns-multicloud** and click on the name.

![](https://cdn-images-1.medium.com/max/3144/1*SClV-UeJSASQyc5c9oJeeA.png)

You will be taken to the **Confirm Changes** section. Make sure the details are correct. Mine look like this:

![Confirm Changes](https://cdn-images-1.medium.com/max/2000/1*TPGibkYMQNU0TlZoJf-OUg.png)*Confirm Changes*

Click the Update VCS Settings button.

You now have the option to change the setting for **Automatic Runs** if you would like.

Terraform can be set to either automatically run a plan and apply for the updated commit or it can be configured to only run the plan and apply if a file in a specific path is changed.

I will keep the default of automatic, which is the **always trigger runs option**.

![](https://cdn-images-1.medium.com/max/3396/1*Lo8ZsH8_7uAikvUhJZm1vw.png)

Finally, click the **Update VCS button**.

Your plan will now be executed by Terraform Cloud; if you select the runs menu item you should see that your run is there but it needs confirmation. Click on the run and then you can see that the plan has completed and Terraform Cloud is waiting for you to confirm and apply the plan.

To allow for automatically applying the changes you could select the settings General option.

![Settings General](https://cdn-images-1.medium.com/max/2000/1*1YBWc8YDa4ink9wFvU08gQ.png)*Settings General*

Then change the Apply Method section to Auto Apply.

![](https://cdn-images-1.medium.com/max/3192/1*pjMyjzJecCSFTPv1wHdfig.png)

More in-depth documentation can be found in the [Connecting VCS Providers to Terraform Cloud](https://www.terraform.io/docs/cloud/vcs/index.html) documentation.

You could now make changes to the files and have the system automatically plan and apply them.

## Exploring the Repository

The repository has a number of files within it. We will look at each terraform file individually. The files represent areas of concern for the deployment.

    => tree
     .
     ├── LICENSE
     ├── README.md
     ├── aws.tf
     ├── azure.tf
     ├── main.tf
     ├── gcp.tf
     ├── outputs.tf
     └── variables.tf
     0 directories, 8 files

[**main.tf](https://github.com/lhaig/dns-multicloud/blob/master/main.tf)**

This file contains all the general items such as provider blocks and the backend configuration.

    # Remote Backend Configuration:

    terraform {
      required_version = ">= 0.12.0
      backend "remote" {
        hostname     = "app.terraform.io"
        organization = "dns-multicloud-org"
        workspaces {
          name = "dns-multicloud"
        }
      }
    }

    # AWS General Configuration

    provider "aws" {
      version = "~> 2.0"
      region  = var.aws_region
    }

    # GCP General Configuration

    provider "google" {
      version = "~> 2.9"
      project = var.gcp_project
      region  = var.gcp_region
    }

    # Azure General Configuration

    provider "azurerm" {
      version = "~>1.32.1"
    }

You will need to update the following sections with the details for your environment.

    dns-multicloud-org (Your organization name)
    dns-multicloud (Your workspace name)

**Save the file and commit it to your repository.**

We will now step through the other files in the repository.

[**azure.tf](https://github.com/lhaig/dns-multicloud/blob/master/azure.tf)**

This file describes the creation of the delegated zone that is hosted in the Azure DNS service. The declaration creates a dedicated [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups) for the hosted DNS to minimise the risk of it being deleted during normal day to day operations.

    #Azure SUBZONE

    resource "azurerm_resource_group" "dns_resource_group" {
      count = var.create_azure_dns_zone ? 1 : 0
      name     = "${var.namespace}DNSrg"
      location = var.azure_location
    }

    resource "azurerm_dns_zone" "azure_sub_zone" {
      count = var.create_azure_dns_zone ? 1 : 0
      name                = "${var.namespace}.azure.${var.hosted-zone}"
      resource_group_name = "${azurerm_resource_group.dns_resource_group.0.name}"
      tags = {
        name        = var.namespace
        owner       = var.owner
        created-by  = var.created-by
      }
    }

[**gcp.tf](https://github.com/lhaig/dns-multicloud/blob/master/gcp.tf)**

This file describes the creation of the delegated zone that is hosted in the GCP DNS service. One thing to note is that when you create a zone in GCP, the dns_name argument needs to have a DNS name with the . at the end 
(e.g. *main.gcp.hashidemos.io.*). Don’t remove the period from the code.

    # GCP SUBZONE

    resource "google_dns_managed_zone" "gcp_sub_zone" {
      count = var.create_gcp_dns_zone ? 1 : 0
      name              = "${var.namespace}-zone"
      dns_name          = "${var.namespace}.gcp.${var.hosted-zone}."
      project           = var.gcp_project
      description       = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
      labels = {
        name = var.namespace
        owner = var.owner
        created-by = var.created-by
      }
    }

[**aws.tf](https://github.com/lhaig/dns-multicloud/blob/master/aws.tf)**

This file contains the declared resources for AWS. It is the main file that does the final configuration of the delegated domains for each Cloud Provider.

Let us step through them.

This section in the beginning uses the data block to gather information about the current AWS hosted zone.

    # Query the current AWS master zone

    data "aws_route53_zone" "main" {
      name = var.hosted-zone
    }

This section is where the delegated [Route53](https://aws.amazon.com/route53/) zones that will be used in AWS are described. It then uses an **aws_route53_record** resource to create the NS records for the delegated zone which it gathers as output from the zone created earlier.

    # AWS SUBZONE

    resource "aws_route53_zone" "aws_sub_zone" {
      count = var.create_aws_dns_zone ? 1 : 0
      name = "${var.namespace}.aws.${var.hosted-zone}"
      comment = "Managed by Terraform, Delegated Sub Zone for AWS for ${var.namespace}"

      tags = {
        name        = var.namespace
        owner       = var.owner
        created-by  = var.created-by
      }
    }

    resource "aws_route53_record" "aws_sub_zone_ns" {
      count = var.create_aws_dns_zone ? 1 : 0
      zone_id = "${data.aws_route53_zone.main.zone_id}"
      name    = "${var.namespace}.aws.${var.hosted-zone}"
      type    = "NS"
      ttl     = "30"

      records = [
        for awsns in aws_route53_zone.aws_sub_zone.0.name_servers:
        awsns
      ]
    }

This section creates the Azure delegated zone using the outputs from the resources in the [azure.tf](https://github.com/lhaig/dns-multicloud/blob/master/azure.tf) file.

    # Azure SUBZONE

    resource "aws_route53_zone" "azure_sub_zone" {
      count = var.create_azure_dns_zone ? 1 : 0
      name = "${var.namespace}.azure.${var.hosted-zone}"
      comment = "Managed by Terraform, Delegated Sub Zone for Azure for ${var.namespace}"

      tags = {
        name        = var.namespace
        owner       = var.owner
        created-by  = var.created-by
      }
    }

    resource "aws_route53_record" "azure_sub_zone_ns" {
      count = var.create_azure_dns_zone ? 1 : 0
      zone_id = "${data.aws_route53_zone.main.zone_id}"
      name    = "${var.namespace}.azure.${var.hosted-zone}"
      type    = "NS"
      ttl     = "30"

      records = [
        for azurens in azurerm_dns_zone.azure_sub_zone.0.name_servers:
        azurens
      ]
    }

This section creates the GCP delegated zone using the outputs from the resources in the [gcp.tf](https://github.com/lhaig/dns-multicloud/blob/master/gcp.tf) file.

    # GCP SubZone

    resource "aws_route53_zone" "gcp_sub_zone" {
      count = var.create_gcp_dns_zone ? 1 : 0
      name          = "${var.namespace}.gcp.${var.hosted-zone}"
      comment       = "Managed by Terraform, Delegated Sub Zone for GCP for  ${var.namespace}"
      force_destroy = false
      tags = {
        name           = var.namespace
        owner          = var.owner
        created-by     = var.created-by
     }
    }

    resource "aws_route53_record" "gcp_sub_zone" {
      count = var.create_gcp_dns_zone ? 1 : 0
      zone_id = "${data.aws_route53_zone.main.zone_id}"
      name    = "${var.namespace}.gcp.${var.hosted-zone}"
      type    = "NS"
      ttl     = "30"

      records = [ 
         for gcpns in
           google_dns_managed_zone.gcp_sub_zone.0.name_servers:
         gcpns
        ]
     }

[outputs.tf](https://github.com/lhaig/dns-multicloud/blob/master/outputs.tf)

The last file is the [outputs.tf](https://github.com/lhaig/dns-multicloud/blob/master/outputs.tf) file. In this file we describe the outputs that we think will be needed when we want to use these zones when we are creating resources in the cloud providers.

    output "aws_sub_zone_id" {
      value = aws_route53_zone.aws_sub_zone.*.zone_id
    }

    output "aws_sub_zone_nameservers" {
      value = aws_route53_zone.aws_sub_zone.*.name_servers
    }

    output "azure_sub_zone_name" {
      value = azurerm_dns_zone.azure_sub_zone.*.id
    }

    output "azure_sub_zone_nameservers" {
      value = azurerm_dns_zone.azure_sub_zone.*.name_servers
    }

    output "azure_dns_resourcegroup" {
      value = azurerm_resource_group.dns_resource_group.*.name
    }

    output "gcp_dns_zone_name" {
      value = google_dns_managed_zone.gcp_sub_zone.*.name
    }

    output "gcp_dns_zone_nameservers" {
      value = google_dns_managed_zone.gcp_sub_zone.*.name_servers
    }

The outputs to take note of for use in other deployments are:

AWS — aws_sub_zone_id

Azure — azure_dns_resourcegroup

GCP — gcp_dns_zone_name

After you have customised the terraform files to your liking, save the files and commit them to the git repository.

When you now push the changes to the repository, Terraform Cloud will pick up these changes and run the plan for this repository.

## Conclusion

As you can see it is quite easy to utilize Terraform when you need to work with multiple cloud providers at once to deploy resources. Using this capability we were able to deploy our DNS zones easily without too much work. Using Terraform Cloud to host your state files and workflows will allow you to better utilise the results and outputs of the deployment in a secure, scalable manner.

I will create a future blog post that will show how one would use the outputs we created in this blog post to deploy resources in each cloud platform and provide them each with DNS records.

# dns-multicloud

This repository is part of a blog post published here

[Haigmail](https://www.haigmail.com/2019/10/08/multi-cloud-dns-delegated-sub-domain-with-terraform-and-terraform-cloud/)

and here

[Medium](https://medium.com/hashicorp-engineering/deploying-dns-delegated-subdomains-using-terraform-cloud-94be8b0009aa)
