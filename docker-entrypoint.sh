#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

# install missing gems
bundle check || bundle install --jobs 20 --retry 5

# prepare the db
bundle exec rails db:prepare

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails assets:precompile
fi

# Remove pre-existing puma/passenger server.pid
rm -f tmp/pids/server.pid

# run passed commands
echo "Executing: bundle exec ${@}"
bundle exec ${@}
