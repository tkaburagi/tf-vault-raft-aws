#!/bin/bash

PRV_IP_0=10.10.0.50
PRV_IP_1=10.10.0.51
PRV_IP_2=10.10.0.52
CA_CERT=$(cat /Users/kabu/hashicorp/certs/vaultca-hashidemos.crt.pem)
CLIENT_CERT=$(cat /Users/kabu/hashicorp/certs/vaultvault-hashidemos.crt.pem)
CLIENT_KEY=$(cat /Users/kabu/hashicorp/certs/vaultvault-hashidemos.key.pem)

PUB_IP_0=$(
  aws ec2 describe-addresses \
        --filters "Name=tag-key,Values=Name" \
                  "Name=tag-value,Values=kabu_vault_eip" \
        | jq '.Addresses | sort_by(.PrivateIpAddress)' \
        | jq -r '.[0].PublicIp'
  )

echo "PUB_IP_0: "${PUB_IP_0}

PUB_IP_1=$(
  aws ec2 describe-addresses \
        --filters "Name=tag-key,Values=Name" \
                  "Name=tag-value,Values=kabu_vault_eip" \
        | jq '.Addresses | sort_by(.PrivateIpAddress)' \
        | jq -r '.[1].PublicIp'
  )

echo "PUB_IP_1: "${PUB_IP_1}


PUB_IP_2=$(
  aws ec2 describe-addresses \
        --filters "Name=tag-key,Values=Name" \
                  "Name=tag-value,Values=kabu_vault_eip" \
        | jq '.Addresses | sort_by(.PrivateIpAddress)' \
        | jq -r '.[2].PublicIp'
  )

echo "PUB_IP_2: "${PUB_IP_2}

# Init Learder
echo "# Init Learder"
VTOKEN=$(
  ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
  -o "StrictHostKeyChecking no" \
  VAULT_ADDR=https://${PRV_IP_0}:8200 ./vault operator init -format=json -tls-skip-verify | jq -r '.root_token'
)

echo "VAULT TOKEN: "$VTOKEN

echo "#### NODE0 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
cat vault.log

# Check Status
echo "#### NODE0 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=https://${PRV_IP_0}:8200 ./vault status -tls-skip-verify

echo "#### NODE1 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_1} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=https://${PRV_IP_1}:8200 ./vault status -tls-skip-verify

echo "#### NODE2 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_2} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=https://${PRV_IP_2}:8200 ./vault status -tls-skip-verify