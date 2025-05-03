```mermaid
graph TD
    %% Definições de estilo
    classDef vpc fill:#f9f9f9,stroke:#333,stroke-width:2px,color:black
    classDef subnet fill:#d1e0e0,stroke:#333,stroke-width:1px,color:black
    classDef gateway fill:#ffcc99,stroke:#333,stroke-width:1px,color:black
    classDef routeTable fill:#ccffcc,stroke:#333,stroke-width:1px,color:black
    classDef nat fill:#ffb366,stroke:#333,stroke-width:1px,color:black
    classDef internet fill:#cce5ff,stroke:#333,stroke-width:1px,color:black
    
    %% VPC
    VPC["VPC<br/>(172.31.0.0/16)"] 
    
    %% Subnets
    PubSub1["Subnet Pública EC2 #1<br/>172.31.1.0/24<br/>us-east-1a"]
    PubSub2["Subnet Pública EC2 #2<br/>172.31.2.0/24<br/>us-east-1b"]
    PrivSub1["Subnet Privada RDS #1<br/>172.31.101.0/24<br/>us-east-1a"]
    PrivSub2["Subnet Privada RDS #2<br/>172.31.102.0/24<br/>us-east-1b"]
    
    %% Internet Gateway
    IGW["Internet Gateway"]
    
    %% Route Tables
    PubRT["Route Table Pública<br/>(0.0.0.0/0 → Internet Gateway)"]
    PrivRT1["Route Table Privada #1<br/>(0.0.0.0/0 → NAT Gateway #1)"]
    PrivRT2["Route Table Privada #2<br/>(0.0.0.0/0 → NAT Gateway #2)"]
    
    %% NAT Gateways e Elastic IPs
    EIP1["Elastic IP #1"]
    EIP2["Elastic IP #2"]
    NAT1["NAT Gateway #1"]
    NAT2["NAT Gateway #2"]
    
    %% Internet
    Internet["Internet"]
    
    %% Conexões
    VPC --> PubSub1
    VPC --> PubSub2
    VPC --> PrivSub1
    VPC --> PrivSub2
    VPC --> IGW
    
    PubSub1 --> PubRT
    PubSub2 --> PubRT
    
    PrivSub1 --> PrivRT1
    PrivSub2 --> PrivRT2
    
    PubRT --> IGW
    
    EIP1 --> NAT1
    EIP2 --> NAT2
    
    NAT1 --> PrivRT1
    NAT2 --> PrivRT2
    
    IGW --> Internet
    
    %% Aplicando classes de estilo
    class VPC vpc
    class PubSub1,PubSub2,PrivSub1,PrivSub2 subnet
    class IGW gateway
    class PubRT,PrivRT1,PrivRT2 routeTable
    class NAT1,NAT2,EIP1,EIP2 nat
    class Internet internet
```


# Projeto de Infraestrutura como Código com Terraform na AWS

Este projeto utiliza o Terraform para provisionar e gerenciar recursos na AWS de forma automatizada e declarativa.

## O que é Terraform?

Terraform é uma ferramenta de infraestrutura como código (IaC) que permite definir e provisionar infraestrutura de forma declarativa. Com o Terraform, você escreve código que define os recursos que deseja criar, modificar ou excluir, e o Terraform se encarrega de executar essas operações.

## Estrutura do Projeto

```
iac-terraform-aws/
├── main.tf           # Arquivo principal com definições de recursos
├── variables.tf      # Declaração de variáveis
├── outputs.tf        # Saídas do Terraform
├── terraform.tfvars  # Valores das variáveis
└── modules/          # Módulos reutilizáveis
```

## Comandos Básicos do Terraform

### Inicialização

```bash
terraform init
```

O comando `terraform init` inicializa o diretório de trabalho do Terraform:
- Baixa e instala os providers necessários (AWS, neste caso)
- Inicializa o backend para armazenar o estado
- Baixa e instala módulos referenciados

### Formatação

```bash
terraform fmt
```

O comando `terraform fmt` formata automaticamente o código Terraform para seguir as convenções recomendadas:
- Alinha e organiza blocos de código
- Padroniza indentação e espaçamento
- Facilita a manutenção e leitura do código

### Validação

```bash
terraform validate
```

O comando `terraform validate` verifica se a configuração é sintaticamente válida e internamente consistente:
- Verifica erros de sintaxe
- Valida referências entre recursos
- Confirma se os tipos de variáveis estão corretos

### Planejamento

```bash
terraform plan
```

O comando `terraform plan` cria um plano de execução:
- Compara o estado atual com o estado desejado
- Mostra as alterações que serão realizadas (criar, modificar, destruir)
- Permite revisar as mudanças antes de aplicá-las
- Não faz nenhuma alteração real na infraestrutura

### Aplicação

```bash
terraform apply
```

O comando `terraform apply` implementa as alterações planejadas:
- Executa primeiro um `plan` e pede confirmação
- Cria, modifica ou destrói recursos conforme necessário
- Atualiza o arquivo de estado com as mudanças realizadas
- Pode ser usado com `-auto-approve` para pular a confirmação

### Destruição

```bash
terraform destroy
```

O comando `terraform destroy` remove todos os recursos gerenciados pelo Terraform:
- Destrói todos os recursos criados pelo Terraform
- Atualiza o arquivo de estado
- Útil para ambientes temporários ou de teste

## Boas Práticas

1. **Controle de Versão**: Mantenha seus arquivos Terraform em um repositório Git.
2. **Módulos**: Use módulos para reutilizar código e manter a organização.
3. **Variáveis**: Parametrize suas configurações usando variáveis.
4. **Estado Remoto**: Configure um backend remoto para armazenar o estado (S3, por exemplo).
5. **Workspace**: Use workspaces para gerenciar múltiplos ambientes.
6. **Documentação**: Documente seus recursos e módulos.

## Como Iniciar

1. Configure suas credenciais da AWS:
   ```bash
   export TF_AWS_ACCESS_KEY_ID="sua-access-key"
   export TF_AWS_SECRET_ACCESS_KEY="sua-secret-key"
   ```

2. Inicialize o projeto:
   ```bash
   terraform init
   ```

3. Planeje as mudanças:
   ```bash
   terraform plan
   ```

4. Aplique as mudanças:
   ```bash
   terraform apply
   ```

## Recursos Adicionais

- [Documentação Oficial do Terraform](https://www.terraform.io/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
