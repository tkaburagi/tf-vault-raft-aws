#!/bin/bash

PUB_IP_0=
PUB_IP_1=
PUB_IP_2=

# Init Learder
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_0}:8200 ./vault operator init

# Join Cluster
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_1} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_1}:8200 ./vault operator raft join http://${PUB_IP_0}:8200

ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_2} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_2}:8200 ./vault operator raft join http://${PUB_IP_0}:8200

# Check Status
echo "#### NODE1 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_0}:8200 ./vault status

echo "#### NODE2 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_1} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_1}:8200 ./vault status

echo "#### NODE3 STATUS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_2} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_2}:8200 ./vault status

echo "#### LIST RAFT PEERS"
ssh -i ~/.ssh/hashistack.pem ubuntu@${PUB_IP_0} \
-o "StrictHostKeyChecking no" \
VAULT_ADDR=http://${PUB_IP_0}:8200 ./vault operator raft list-peers