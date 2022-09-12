# Running
buliding docker container
```shell
docker build -t cloudyna:latest -f docker/DOCKERFILE .
```
running container
```shell
docker compose run --rm cloudyna
```
running terraform
```shell
terragrunt run-all apply --terragrunt-non-interactive --terragrunt-working-dir terragrunt
```