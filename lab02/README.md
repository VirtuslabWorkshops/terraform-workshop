# Terraform Fundamentals - Lab 02

## Objectives

- Keep your Terraform configuration clean and valid.

## Formatting and Validating Terraform Code

It is important to keep your Terraform code formatted and check its validity before applying. Fortunately, Terraform provides the tools to do so.

First, let's check the formatting. Run the following command to check if the code is properly formatted:

```bash
cd ./lab02/infra
terraform fmt -check -recursive
```

If the output is empty, it means that your Terraform code is well-formatted. Otherwise, it will print incorrectly formatted files.
To view what exactly is wrong with the formatting, run the following command:

```bash
terraform fmt -check -recursive -diff
```

Once you have fixed the formatting, run the command again.

Next, we want to check if our Terraform code is valid. Run the following command to check that:

```bash
terraform init
terraform validate
```

Follow the instructions to make your code valid and run the command again.