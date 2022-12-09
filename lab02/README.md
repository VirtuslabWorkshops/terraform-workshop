# Terraform fundamentals - Lab 02

## Objectives

- Keep your terraform config clean and valid

## Formatting and validating terraform code

You want to keep your terraform code formatted and check it validity before applying. Terraform gives you the tools to do so. First let's check formatting. Run the following command to check if code is properly formatted.

```bash
cd ./lab02/infra
terraform fmt -check -recursive
```

If the output is empty, it means that your terraform code is well formatted, otherwise it will print incorrectly formatted files. 
You can view what exactly is wrong with formatting:

```bash
terraform fmt -check -recursive -diff
```

Fix the formatting and run the above command again.
Next, we want to check if our terraform code is valid. Run the following command to check that.

```bash
terraform init
terraform validate
```

Follow instructions to make your code valid and run above command again.
