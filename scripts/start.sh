#! /bin/bash

if [ "$RAILS_ENV" == "development" ]; then
  # Espera o servidor do MySQL responder
  until $(curl --output /dev/null --silent --head --fail http://mysql:3306); do
    sleep 1
  done
fi

# Configura o banco de dados
bundle exec rails db:create
bundle exec rails db:migrate
# Precompile
if [ "$RAILS_ENV" == "production" ]; then
  rails assets:precompile
fi
# Liga o server
bundle exec rails server -b 0.0.0.0 -p 80
