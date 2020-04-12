#
# Provisionamento AZ no AWS usando Terraform
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

provider "aws" {
  alias = "us-east-2"
  version = "~> 2.0"
  region  = "us-east-2"
}

# Setando back end para Bucket na AWS 
terraform {
  backend "s3" {
  bucket = "labs_bucket_terraform"
  key = "LABS/terraform/terraform.tfsate"
  region= "us-east-1"
  }
}

# Provisionado 3 máquinas 
resource "aws_instance" "vm" {
  count = 3
  ami = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
}

resource "aws_instance" "vm4" {
  ami = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm4"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
  depends_on = ["aws_s3_bucket.vm4"]
}

resource "aws_instance" "vm5" {
  ami = "${var.amis["us-east-1"]}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm5"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
}

// Instância com depedência do Dynamo DB provisionando em região diferente
resource "aws_instance" "vm6" {
  provider = "aws.us-east-2"
  ami = "${var.amis["us-east-2"]}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm6"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"]
  depends_on = ["aws_dynamodb_table.dynamodb-homologacao"]
}
// Teste de varíavel na Imagem e provisionamento em região diferente
resource "aws_instance" "vm7" {
  provider = "aws.us-east-2"
  ami = "${var.amis["us-east-2"]}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm7"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"]
}

resource "aws_instance" "vm8" {
  provider = "aws.us-east-2"
  ami = "${var.amis["us-east-2"]}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "vm8"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"]
}

// Instância com dynamo DB com pagamento por requisição.
resource "aws_dynamodb_table" "dynamodb-homologacao" {
  provider = "aws.us-east-2"
  name           = "TesteHomologacao"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "TesteHomologacao"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "teste"
    type = "S"
  }
}

// Criação de Bucket
resource "aws_s3_bucket" "vm4" {
  bucket = "labs-milton-producao"
  acl    = "private"

  tags = { 
    Name = "labs-milton-homologacao"
  }
}

