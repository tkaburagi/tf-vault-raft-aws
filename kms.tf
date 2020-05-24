resource "aws_kms_key" "kms_key" {
    description             = "KKabu Vault Unseal"
}

resource "aws_kms_alias" "kms_key" {
    name          = "alias/kabu-vault-autounseal"
    target_key_id = aws_kms_key.kms_key.id
}