#! /bin/sh

# Espera o servidor do MySQL responder
until $(curl --output /dev/null --silent --head --fail http://mysql:3306); do
    sleep 1
done
# Configura o banco de dados
bundle exec rails db:create
bundle exec rails db:migrate
# Liga o server
bundle exec rails server -b 0.0.0.0 -p 80
