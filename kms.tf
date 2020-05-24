resource "aws_kms_key" "kms_key" {
    description             = "KMS key 1"
    deletion_window_in_days = 10

}

resource "aws_kms_alias" "kms_key" {
    name          = "kabu-vault-autounseal"
    target_key_id = aws_kms_key.kms_key.id
}