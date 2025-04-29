FROM ruby:3.4.1

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev

# Cria diretório de trabalho
WORKDIR /app

# Copia os arquivos para o container
COPY . .

# Instala as gems
RUN gem install bundler && bundle install

# Expõe a porta padrão do Sinatra
EXPOSE 4567

# Comando para iniciar o Sinatra
CMD ["ruby", "main.rb"]