#!/bin/sh

set -e

if [ "$RAILS_ENV" = "production" ]; then
  echo "Environment: production"
else
  echo "Environment: development"
fi

# install missing gems
echo "Checking dependencies..."
bundle check || bundle install --jobs 20 --retry 5

# prepare the db
echo "Executing: bundle exec rails db:prepare"
bundle exec rails db:prepare

if [ "$RAILS_ENV" = "production" ]; then
  echo "Executing: bundle exec rails assets:precompile"
  bundle exec rails assets:precompile
fi

# Remove pre-existing puma/passenger server.pid
rm -f tmp/pids/server.pid

# run passed commands
echo "Executing: bundle exec ${@}"
bundle exec ${@}
