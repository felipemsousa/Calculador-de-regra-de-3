# 🚀 Gerenciamento de Cluster Kubernetes com Kind

Este projeto contém scripts para criar, configurar e deletar clusters locais Kubernetes utilizando o **Kind**. Ele automatiza a criação do cluster, instalação do **Metric Server**, do **Ingress NGINX**, e a configuração de porta personalizada.

## 📁 Estrutura do Projeto

````
├── .env.sh # Variáveis de ambiente usadas pelos scripts
├── cluster-config.yaml # Arquivo de configuração do cluster Kind
├── create-cluster-kind.sh # Script para criar e configurar o cluster
├── delete-cluster-kind.sh # Script para deletar o cluster
````

## ⚙️ Pré-requisitos

Antes de utilizar os scripts, certifique-se de que as seguintes ferramentas estão instaladas:

- [Docker](https://www.docker.com/)
- [Kind](https://kind.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## 📄 Descrição dos Arquivos

### `.env.sh`
Define variáveis utilizadas pelos scripts:

- `CLUSTER_NAME`: Nome do cluster a ser criado (ex: `cluster-local`)
- `CONFIG_FILE`: Caminho do arquivo de configuração (ex: `cluster-config.yaml`)
- `CONTAINER_PORT`: Porta a ser mapeada no serviço Ingress NGINX (ex: `30000`)

---

### `cluster-config.yaml`
Configuração padrão do cluster com:

- 1 nó de controle (`control-plane`)
- 2 nós de trabalho (`worker`)
- Mapeamento de porta do host para o container (`hostPort: 80` → `containerPort: 40000`)

> 🔧 A porta do container será substituída pela definida em `CONTAINER_PORT` durante a criação.

---

### `create-cluster-kind.sh`
Cria e configura automaticamente o cluster com:

- Verificações de ferramentas instaladas
- Substituição dinâmica da porta no arquivo de configuração
- Criação do cluster com `kind`
- Instalação e configuração do **Metric Server**
- Instalação do **Ingress NGINX**
- Mapeamento da porta definida para o serviço `ingress-nginx-controller`

#### ▶️ Como rodar
```bash
$ chmod +x create-cluster-kind.sh
$ ./create-cluster-kind.sh
```

### `delete-cluster-kind.sh`
Remove o cluster especificado pela variável CLUSTER_NAME.

#### 🗑️ Como rodar
```bash
$ chmod +x delete-cluster-kind.sh
$ ./delete-cluster-kind.sh
```

#### ✅ Exemplo de uso completo
```bash
# Ajuste as variáveis, se necessário
nano .env.sh

# Crie o cluster
./create-cluster-kind.sh

# Quando terminar, delete o cluster
./delete-cluster-kind.sh
```
### 📌 Observações

- O script faz uso do `sed` para substituir dinamicamente a porta no arquivo `yaml`.

- O `Metric Server` é configurado para aceitar conexões inseguras com `--kubelet-insecure-tls`.

- O mapeamento de porta do `Ingress NGINX` é adicionado via `kubectl patch`.


## 🔔 Atenção

    Este projeto foi desenvolvido para facilitar a automação de ambientes locais Kubernetes com o Kind.