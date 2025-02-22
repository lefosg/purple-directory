# Purple Directory

## Description

![alt text](diagram.png)

An infrastructure hosted on Azure which contains a domain controller and a few workstation VMs, to demonstrate how a simple infrastructure can be:
- set up
- monitored
- attacked

and lastly create AD-specific rules.

There are a few VMs here:
- The domain controller
- A couple of workstations
- The SIEM (Wazuh) which monitors the other VMs

The infrastructure is provided as IaC using terraform.

A Point2Site VPN is set up to connect with your desired method (configure it after it is spawned in Azure)

## How to run

First, log in to azure via: 

```console
az login
```

Second, parameterize the `vars.tfvals` file the way you want (if you want).

Then, upload the infrastructure in azure via
```console
terraform init
terraform apply -auto-approve -var-file='vars.tfvals'
```

TODO: automate platform installment

To destroy the infrastructure, run:
```console
terraform destroy -auto-approve -var-file='vars.tfvals'
```