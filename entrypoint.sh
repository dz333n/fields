#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Create and migrate the database (interview task requirement!)
rails db:create
rails db:migrate RAILS_ENV=development
rails db:migrate RAILS_ENV=test

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"