resource "aws_instance" "vault_ec2" {
    ami = var.ami
    count = var.vault_instance_count
    instance_type = var.vault_instance_type
    vpc_security_group_ids = [aws_security_group.vault_security_group.id]
    tags = merge(var.tags, map("Name", "${var.vault_instance_name}-${count.index}"))
    subnet_id = aws_subnet.public.*.id[0]
    key_name = aws_key_pair.deployer.id
    associate_public_ip_address = true
    private_ip = var.private_ips[count.index]

    user_data =<<-EOF
                #!/bin/sh

                cd /home/ubuntu
                mkdir vault-raft-data
                                                       え
                sudo apt-get install zip unzip

                wget "${var.vault_dl_url}"
                wget https://raw.githubusercontent.com/tkaburagi/vault-configs/master/vault-tempate-aws.hcl

                unzip vault*.zip
                rm vault*zip

                chmod +x vault

                export AWS_SECRET_ACCESS_KEY=${var.secret_key}
                export AWS_ACCESS_KEY_ID=${var.access_key}
                export VAULT_AWSKMS_SEAL_KEY_ID=${aws_kms_key.kms_key.key_id}
                export API_ADDR_REPLACE=http://${var.vault_fqdn}
                export VAULT_ADDR=http://${var.vault_fqdn}
                export CLUSTER_ADDR_REPLACE=${var.private_ips[count.index]}
                export TLS_CERT_FILE_REPLACE=${var.tls_cert_file}
                export TLS_KEY_FILE_REPLACE=${var.tls_key_file}

                sed "s|API_ADDR_REPLACE|`echo $API_ADDR_REPLACE`|g" vault-tempate-aws.hcl > config-0.hcl
                sed "s|CLUSTER_ADDR_REPLACE|`echo $CLUSTER_ADDR_REPLACE`|g" config-0.hcl > config-1.hcl
                sed "s|NODE_ID_REPLACE|`echo $CLUSTER_ADDR_REPLACE`|g" config-1.hcl > config-2.hcl
                sed "s|TLS_CERT_FILE_REPLACE|`echo TLS_CERT_FILE_REPLACE`|g" config-2.hcl > config.hcl
                sed -i "s|TLS_KEY_FILE_REPLACE|`echo TLS_KEY_FILE_REPLACE`|g" config.hcl > config.hcl


                rm config-*.hcl

                sleep 60

                nohup ./vault server -config /home/ubuntu/config.hcl start -log-level=debug > vault.log &

              EOF
}
