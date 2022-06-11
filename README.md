# groupthink

|  Builds  |    Security   | Quality |
|:--------:|:-------------:|:-------:|
[![Ruby on Rails CI](https://github.com/rakaur/groupthink/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/rubyonrails.yml)|[![Brakeman Scan](https://github.com/rakaur/groupthink/actions/workflows/brakeman.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/brakeman.yml)|[![Maintainability](https://api.codeclimate.com/v1/badges/2581ad79c4d6576a4bfa/maintainability)](https://codeclimate.com/github/rakaur/groupthink/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2581ad79c4d6576a4bfa/test_coverage)](https://codeclimate.com/github/rakaur/groupthink/test_coverage)|[![CodeQL](https://github.com/rakaur/groupthink/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/codeql-analysis.yml)|[![codebeat badge](https://codebeat.co/badges/f7c95fc1-54ab-4f68-b6bd-a50aebbc6827)](https://codebeat.co/projects/github-com-rakaur-groupthink-main)
[![Ruby on Rails CI](https://github.com/rakaur/groupthink/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/rubyonrails.yml)|[![Brakeman Scan](https://github.com/rakaur/groupthink/actions/workflows/brakeman.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/brakeman.yml)|[![Maintainability](https://api.codeclimate.com/v1/badges/ee3412cce979b5e8af59/maintainability)](https://codeclimate.com/github/rakaur/groupthink/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ee3412cce979b5e8af59/test_coverage)](https://codeclimate.com/github/rakaur/groupthink/test_coverage)|[![CodeQL](https://github.com/rakaur/groupthink/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/rakaur/groupthink/actions/workflows/codeql-analysis.yml)|[![codebeat badge](https://codebeat.co/badges/f7c95fc1-54ab-4f68-b6bd-a50aebbc6827)](https://codebeat.co/projects/github-com-rakaur-groupthink-main)

---

Repository was created using `ruby-3.1.0` and `rails-7.0.3` via:

  ```
  rails new groupthink --database=postgresql --asset-pipeline=propshaft
                       --javascript=importmap --skip-action-mailer
                       --skip-action-cable --skip-active-storage
                       --skip-active-job
  ```

---

## Configuration

### Docker

For production, the included `Dockerfile` should be sufficient. The entry point
is a shell script that verifies the dependencies, runs `rails db:prepare` and
some other minor checks and setup and then executes puma. Set the
appropriate environment variables, including `RAILS_ENV=production`, database
configuration and a `SECRET_KEY_BASE` that would otherwise be in `master.key`.
See `.env-example`.

For development, the included `docker-compose.yml` will run the application and
a postgres container alongside. The application files will be shared with the
container, and the entry point will be `rails server`. You will need
to set `POSTGRES_PASSWORD` in `.env` for initial setup of the database
container. See `.env-example`.

The file `db/seeds.rb` contains data essential for a brand new database to
function properly (that the app assumes is always there, essentially). Seed data
will always load for production. For development, the data modeled within
`tests/fixtures/` can be loaded into the development database by running:

  `$ rails db:fixtures:load`

This is the data I use for development, and it is designed with both development
and testing in mind.

### Database

In lieu of CLI flags, Rails uses `RAILS_ENV` to determine the current
environment. For development you can usually leave this alone as it defaults to
"development," but if you want production you need to set `RAILS_ENV`.

Rails uses a postgresql database, specified via environment variables:

* `DATABASE_HOST`
* `DATABASE_PORT`
* `DATABASE_USER`
* `DATABASE_PASSWORD`

Set these or use a `.env` file. See `.env-example`.

For initial database setup:

  `$ rails db:prepare`

This will create the database if it doesn't exist, and running migrations if it
does.

## Tests

There exists a comprehensive test suite including controller, integration, model,
and system tests.

  `$ rails test`
  `$ rails test:system`

System tests utilizes capybara and selenium. You will need chromedriver and
Google Chrome installed. The system tests will not run in the docker image.

---

So long, and thanks for all the fish.
