# Streams

[![Ruby on Rails CI](https://github.com/rakaur/streams/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/rakaur/streams/actions/workflows/rubyonrails.yml)
[![CodeQL](https://github.com/rakaur/streams/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/rakaur/streams/actions/workflows/codeql-analysis.yml)
[![Brakeman Scan](https://github.com/rakaur/streams/actions/workflows/brakeman.yml/badge.svg)](https://github.com/rakaur/streams/actions/workflows/brakeman.yml)


* Repository was created with:

  ```
  rails new streams --database=postgresql --asset-pipeline=propshaft
                    --javascript=importmap --skip-action-mailer
                    --skip-action-cable --skip-active-storage
                    --skip-active-job
  ```

* Ruby 3.1.0

* Rails 7.0.3

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

### Database

In lieu of CLI flags, Rails uses `RAILS_ENV` to determine the current
environment. For development you can usually leave this alone as it defaults to
"development," but if you want production you need to set `RAILS_ENV`.

Streams uses a postgresql database, specified via environment variables:

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

Streams has a comprehensive test suite including controller, integration, model,
and system tests.

  `$ rails test`
  `$ rails test:system`

System tests utilizes capybara and selenium. You will need chromedriver and
Google Chrome installed. The system tests will not run in the docker image.

## Deployment

### Docker

Deployment with docker should be fairly painless? I've never actually used a
container hosting service but from what I've read AWS ECS works in a manner
similar to docker-compose. Pass the right environment variables to the container
and you should be all set.

### Heroku

Deployment with heroku is push-and-done. Since heroku doesn't run the entry
point script, you may have to run database migrations. Heroku runs `db:setup` so
your first push should work, but `db:setup` does not run migrations.

---

So long, and thanks for all the fish.
