#!/bin/bash
RGNAME=
SANAME=

cat <<EOF > dev.backend.hcl
resource_group_name  = "$RGNAME"
storage_account_name = "$SANAME"
container_name       = "sc-tf-backend-dev"
key                  = "terraform.tfstate"
EOF

xargs -n 1 cp -v dev.backend.hcl<<<"../infra/rg ../infra/vnet ../infra/sql ../infra/kv ../infra/aks_setup ../infra/app"

cat <<EOF > pre.backend.hcl
resource_group_name  = "$RGNAME"
storage_account_name = "$SANAME"
container_name       = "sc-tf-backend-pre"
key                  = "terraform.tfstate"
EOF

xargs -n 1 cp -v pre.backend.hcl<<<"../infra/rg ../infra/vnet ../infra/sql ../infra/kv ../infra/aks_setup ../infra/app"