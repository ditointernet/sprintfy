#! /bin/sh

# Configura o banco de dados
bundle exec rails db:create
bundle exec rails db:migrate
# Precompile
rails assets:precompile
# Liga o server
bundle exec rails server -b 0.0.0.0 -p 80
