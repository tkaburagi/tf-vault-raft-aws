#!/bin/bash

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
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_0}:8200 ./vault operator init -format-json

# Join Cluster
echo "# Join Cluster"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_1} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_1}:8200 ./vault operator raft join http://${PUB_IP_0}:8200

ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_2} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_2}:8200 ./vault operator raft join http://${PUB_IP_0}:8200

# Check Status
echo "#### NODE0 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_0}:8200 ./vault status

echo "#### NODE1 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_1} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_1}:8200 ./vault status

echo "#### NODE2 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_2} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_2}:8200 ./vault status