# Imagem base com Python
FROM python:alpine3.21

# Diretório de trabalho no container
WORKDIR /app

# Copia o arquivo de requisitos para o container
COPY requirements.txt .

# Instala as dependências do arquivo requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação para o container
COPY . .

# Expondo a porta que o Flask vai rodar
EXPOSE 5000

# Criando um usuário não privilegiado para rodar a aplicação
RUN adduser --disabled-password --gecos "" appuser

# Mudando para o usuário não privilegiado
USER appuser

# Comando para rodar a aplicação com Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

