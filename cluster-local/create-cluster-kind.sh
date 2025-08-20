#!/bin/bash

# Importa variáveis do arquivo externo
source ./env.sh

# Verifica se o kind está instalado
if ! command -v kind &> /dev/null; then
    echo "❌ Erro: 'kind' não está instalado."
    exit 1
fi

# Verifica se o kubectl está instalado
if ! command -v kubectl &> /dev/null; then
    echo "❌ Erro: 'kubectl' não está instalado."
    exit 1
fi

# Verifica se o arquivo de configuração existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Erro: Arquivo de configuração '$CONFIG_FILE' não encontrado."
    exit 1
fi

# Cria o cluster
echo "🚀 Criando cluster '$CLUSTER_NAME' com a configuração '$CONFIG_FILE'..."
sed "s/containerPort: .*/containerPort: $CONTAINER_PORT/" "$CONFIG_FILE" | kind create cluster --name "$CLUSTER_NAME" --config=-

# Verifica se o cluster foi criado com sucesso
if [ $? -ne 0 ]; then
    echo "❌ Falha ao criar o cluster '$CLUSTER_NAME'."
    exit 1
fi

# Verifica se o cluster aparece na lista
if kind get clusters | grep -q "^$CLUSTER_NAME$"; then
    echo "✅ Cluster '$CLUSTER_NAME' criado com sucesso!"
    echo "📋 Clusters disponíveis:"
    kind get clusters
else
    echo "⚠️ Cluster '$CLUSTER_NAME' não foi encontrado após criação."
    exit 1
fi

# Instala o Metric-Server
echo "📦 Instalando o Metric-Server no cluster '$CLUSTER_NAME'..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
if [ $? -ne 0 ]; then
    echo "❌ Falha ao instalar o Metric-Server."
    exit 1
fi

# Configura o Metric-Server
echo "⚙️ Configurando o Metric-Server para aceitar conexões inseguras (TLS)..."
kubectl patch -n kube-system deployment metrics-server --type=json \
  -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
if [ $? -ne 0 ]; then
    echo "❌ Falha ao configurar o Metric-Server."
    exit 1
fi

# Instala ingress-nginx
echo "📦 Instalando o ingress-nginx no cluster '$CLUSTER_NAME'..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.1/deploy/static/provider/baremetal/deploy.yaml
if [ $? -ne 0 ]; then
    echo "❌ Falha ao instalar o ingress-nginx."
    exit 1
fi

# Aguarda até o serviço ingress-nginx-controller estar disponível
echo "⏳ Aguardando o serviço 'ingress-nginx-controller' estar disponível..."
kubectl wait --namespace ingress-nginx \
  --for=condition=available deployment/ingress-nginx-controller \
  --timeout=90s

# Adiciona a porta NodePort
echo "🔧 Adicionando a porta $CONTAINER_PORT no serviço ingress-nginx..."
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type='json' \
  -p="[{
    \"op\": \"add\",
    \"path\": \"/spec/ports/0/nodePort\",
    \"value\": $CONTAINER_PORT
}]"
if [ $? -ne 0 ]; then
    echo "❌ Falha ao adicionar o nodePort $CONTAINER_PORT no ingress-nginx."
    exit 1
fi

echo "✅ Cluster '$CLUSTER_NAME' configurado com sucesso!"
