resource "aws_key_pair" "terraform-keypair" {
  key_name   = var.key_name
  public_key = var.key_value
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/*
https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key

id (String) Unique identifier for this resource: hexadecimal representation of the SHA1 checksum of the resource.
private_key_openssh (String, Sensitive) Private key data in OpenSSH PEM (RFC 4716) format.
private_key_pem (String, Sensitive) Private key data in PEM (RFC 1421) format.
public_key_fingerprint_md5 (String) The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. aa:bb:cc:.... Only available if the selected private key format is compatible, similarly to public_key_openssh and the ECDSA P224 limitations.
public_key_fingerprint_sha256 (String) The fingerprint of the public key data in OpenSSH SHA256 hash format, e.g. SHA256:.... Only available if the selected private key format is compatible, similarly to public_key_openssh and the ECDSA P224 limitations.
public_key_openssh (String) The public key data in "Authorized Keys" format. This is populated only if the configured private key is supported: this includes all RSA and ED25519 keys, as well as ECDSA keys with curves P256, P384 and P521. ECDSA with curve P224 is not supported. NOTE: the underlying libraries that generate this value append a \n at the end of the PEM. In case this disrupts your use case, we recommend using trimspace().
public_key_pem (String) Public key data in PEM (RFC 1421) format. NOTE: the underlying libraries that generate this value append a \n at the end of the PEM. In case this disrupts your use case, we recommend using trimspace().
*/