resource "aws_instance" "vault_ec2" {
    ami = var.ami
    count = var.vault_instance_count
    instance_type = var.vault_instance_type
    vpc_security_group_ids = [aws_security_group.vault_security_group.id]
    tags = merge(var.tags, map("Name", "${var.vault_instance_name}-${count.index}"))
    subnet_id = aws_subnet.public.*.id[0]
    key_name = aws_key_pair.deployer.id
    associate_public_ip_address = true

    user_data =<<-EOF
                #!/bin/sh

                cd /home/ubuntu

                sudo apt-get install zip unzip

                wget "${var.vault_dl_url}"
                wget https://raw.githubusercontent.com/tkaburagi/vault-configs/master/remote-vault-template.hcl

                unzip vault*.zip
                rm vault*zip

                chmod +x vault

              EOF
}
