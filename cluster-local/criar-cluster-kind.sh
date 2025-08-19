#!/bin/bash

# Nome do cluster
CLUSTER_NAME="cluster-local"

# Arquivo de configuração
CONFIG_FILE="cluster-config.yaml"

# Verifica se o kind está instalado
if ! command -v kind &> /dev/null; then
    echo "Erro: 'kind' não está instalado'"
    exit 1
fi

# Verifica se o kubectl está instalado
if ! command -v kubectl &> /dev/null; then
    echo "Erro: 'kubectl' não está instalado."
    exit 1
fi

# Verifica se o arquivo de configuração existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erro: Arquivo de configuração '$CONFIG_FILE' não encontrado."
    exit 1
fi

# Cria o cluster
echo "Criando cluster '$CLUSTER_NAME' com a configuração '$CONFIG_FILE'..."
kind create cluster --name "$CLUSTER_NAME" --config "$CONFIG_FILE"

# Verifica se o cluster foi criado
if [ $? -eq 0 ]; then
    echo "✅ Cluster '$CLUSTER_NAME' criado com sucesso!"
    echo "📋 Clusters disponíveis:"
    kind get clusters
else
    echo "❌ Falha ao criar o cluster."
fi
