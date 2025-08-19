# Cálculo de Regra de 3 com Flask

Este é um projeto simples que implementa uma aplicação web utilizando o Flask para calcular a regra de 3. A aplicação oferece uma API RESTful para calcular o valor de "X" a partir de três parâmetros fornecidos: `a`, `b` e `c`.

## Funcionalidades

- **Página Inicial**: Uma interface simples que permite ao usuário inserir os valores de `a`, `b` e `c` para calcular a regra de 3.
- **API de Cálculo**: Endpoint `/calcular` para calcular o valor de `X` a partir de três parâmetros fornecidos.
- **Health Check**: Endpoint `/health` para verificar se o servidor está em funcionamento.

## Requisitos

- Python 3.x
- Flask

## Como Usar

### Passo 1: Clonar o Repositório

Clone este repositório para o seu ambiente local.

```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
cd nome-do-repositorio
```
### Passo 2: Instalar Dependências

Instale as dependências necessárias usando o pip:

```bash
pip install -r requirements.txt
```

### Passo 3: Rodar o Servidor Flask

Instale as dependências necessárias usando o pip:

```bash
python app.py
```

### Passo 4: Testar a API

A API oferece os seguintes endpoints:

- GET /: Renderiza a página inicial, onde você pode inserir os valores para calcular a regra de 3.

- POST /calcular: Recebe os valores a, b e c em formato JSON e retorna o valor de X calculado. Exemplo de requisição:

```bash
{
  "a": 4,
  "b": 6,
  "c": 9
}
```
Resposta esperada:
```bash
{
  "x": 13.5
}
```
Se algum dos parâmetros estiver ausente ou inválido, o servidor retornará um erro 400:
```bash
{
  "error": "Faltam parametros"
}
```

- GET /health: Realiza um check de saúde do servidor e retorna um status.
Resposta esperada:
```bash
{
  "status": "ok",
  "message": "Servico UP"
}
```

## Estrutura do Projeto

- **app.py**: Arquivo principal da aplicação Flask.

- **templates/**: Pasta que contém os templates HTML.

- **index.html**: Página inicial para inserir os valores.

- **requirements.txt**: Lista de dependências para o projeto (caso queira compartilhar com outras pessoas ou em ambientes virtuais).