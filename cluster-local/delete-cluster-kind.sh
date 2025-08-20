#!/bin/bash
source ./env.sh

echo "🗑️  Deletando o cluster '$CLUSTER_NAME' com a configuração '$CONFIG_FILE'..."

if kind delete cluster --name "$CLUSTER_NAME"; then
    # Verifica se o cluster ainda existe
    if kind get clusters | grep -q "^$CLUSTER_NAME$"; then
        echo "⚠️ Cluster '$CLUSTER_NAME' ainda existe após tentativa de exclusão."
        exit 1
    else
        echo "✅ Cluster '$CLUSTER_NAME' deletado com sucesso."
    fi
else
    echo "❌ Falha ao executar o comando de exclusão."
    exit 1
fi
