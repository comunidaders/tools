# Guia de Instalação - AWS CLI, kubectl e Terraform

Este guia fornece instruções passo a passo para a instalação das seguintes ferramentas essenciais:

- [AWS CLI (Amazon Web Services Command Line Interface)](https://aws.amazon.com/cli/)
- [kubectl (Kubernetes Command Line Tool)](https://kubernetes.io/docs/reference/kubectl/)
- [Terraform (Infrastructure as Code)](https://www.terraform.io/)

## Instalação da AWS CLI

A AWS CLI é uma ferramenta de linha de comando oficial da Amazon para interagir com serviços da AWS.

### Linux Ubuntu (via gerenciador de pacotes):

```bash
sudo apt-get update && apt-get install curl unzip -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
```

### macOS (via Homebrew):

```bash
brew install awscli
```

### Windows (via MSI Installer):
Baixe o instalador MSI da AWS CLI em AWS CLI Installer for Windows.
Execute o instalador e siga as instruções na tela.

## Instalação do kubectl:

### Linux:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### macOS (via Homebrew):
```bash
brew install kubectl
```

### Windows (via Chocolatey):
```bash
choco install kubernetes-cli
```

## Instalação do Terraform

### Linux:
```bash
curl -LO "https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip"
unzip terraform_0.15.5_linux_amd64.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/

```

### macOS (via Homebrew):
```bash
brew install terraform
```

### Windows (via Chocolatey):
```bash
choco install terraform
```
