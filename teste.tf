provider "aws" {
  region = "us-east-2" # Altere para sua região desejada
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Criação da VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "minha-vpc"
  }
}

# Criação de uma Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a" # Altere para a zona de disponibilidade desejada

  tags = {
    Name = "minha-subnet-publica"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "minha-internet-gateway"
  }
}

# Criação da tabela de roteamento
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "minha-tabela-de-roteamento-publica"
  }
}

# Associação da Subnet à tabela de roteamento
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Geração da chave SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Armazenamento da chave pública no AWS EC2
resource "aws_key_pair" "generated_key" {
  key_name   = "meu-keypair-terraform" # Nome da chave
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Criação do Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "meu-ec2-sg"
  description = "Security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir SSH de qualquer lugar"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir"
  }

  tags = {
    Name = "Meu EC2 SG"
  }
}

# Criação da instância EC2 usando módulo da comunidade
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name           = "meu-servidor-terraform"
  instance_type  = "t2.micro" # Tipo de instância - altere conforme necessário
  ami            = data.aws_ami.ubuntu.id # AMI do Amazon Linux 2 - altere para a AMI desejada
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public.id

  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name        = "Meu Servidor EC2"
    Environment = "Dev"
  }
}

# Salvando a chave privada em um arquivo local
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/meu-keypair-terraform.pem" # Salva a chave privada no diretório do projeto
  file_permission = "0600"
}


output "ec2_complete_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_instance.public_ip
}


output "ec2_complete_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_instance.public_dns
}
