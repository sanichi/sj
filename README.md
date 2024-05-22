# README

This rails app is for playing the game of Skyjo (2-4 players).

To run/test locally:

* Install the version of ruby in `.ruby-version`.
* Run `bin/bundle install`.
* Overwrite `config/credentials.yml.enc` (it only has a `secret_key_base`) with a new `config/master.key`.
* Make sure you have PostgreSQL running locally.
* Create the unversioned file `config/database.yml` something like this:
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: blah
  password: blah
development:
  <<: *default
  database: sj_development
test:
  <<: *default
  database: sj_test
```
* Run `bin/rails db:create`.
* Sync the development database with the production database if you can.
* If you can't sync then at least create two users (one admin) with `bin/rails c`:
```
User.create!(first_name: "...", last_name: "...", handle: "...", password: "...", admin: true);
User.create!(first_name: "...", last_name: "...", handle: "...", password: "...", admin: false);
```
* Run the app locally on port 3000 with `bin/rails s`.
* Test by running `bin/rake`.
