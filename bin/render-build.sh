#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake data:dl:all
bundle exec rails r scripts/generate_tanaka_db.rb
