# Streams

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
appropriate environment variables, including database configuration and a
`SECRET_KEY_BASE` that would otherwise be in `master.key`. See `.env-example`.

For development, the included `docker-compose.yml` will run the application and
a postgres container alongside. The application files will be shared with the
container, and the entry point will be `rails s -p 3000 -b 0.0.0.0`.

### Database

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
and system tests. To run all tests, execute:

  `$ rails test:all`

Or, more commonly:

  `$ rails test`
  `$ rails test:system`

System tests utilizes capybara and selenium. You will need chromedriver and
Google Chrome installed. The system tests will not run in the docker image.

## Deployment

### Docker

Deployment with docker should be fairly painless? I've never actually used a
container hosting service but from what I've read AWS ECS works in a manner
similar to docker-compose.

### Heroku

Deployment with heroku is push-and-done. Since heroku doesn't run the entry
point script, you may have to run database migrations. Heroku runs `db:setup` so
your first push should work, but `db:setup` does not run migrations.

---

So long, and thanks for all the fish.
