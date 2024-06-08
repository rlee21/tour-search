# tour-search

Tour search page for people interested in booking a tour.

- [Getting Started](#getting-started)
  - [Setup](#setup)
  - [Running the application](#running-the-application)
  - [Running Tests](#running-tests)
  - [Running Linter](#running-linter)

## Getting Started

### Setup

- Set your environment variables
  ```sh
  cp -i ./.env.template ./.env
  ```
  - Native setup
    - Set PostgreSQL user/password
      ```sh
      sudo -u postgres createuser -s tour-search
      sudo -u postgres psql
      postgres=# \password tour-search
      enter tour-search for password
      ```
    - Run setup script
      ```sh
      bin/setup
      ```
  OR

  - Docker setup
    ```sh
    docker compose build
    docker compose run --rm web bin/setup
    ```
### Running the application

- Native
  ```sh
  bin/rails server
  ```

OR

- Docker
  ```sh
  docker compose up
  ```
### Running Tests

- Native
  ```sh
  RAILS_ENV=test bin/rails db:prepare
  RAILS_ENV=test bin/rspec
  ```

OR

- Docker
  ```sh
  docker compose run --rm -e "RAILS_ENV=test" web bin/rails db:prepare
  docker compose run --rm -e "RAILS_ENV=test" web bin/rspec
  ```
### Running Linter

- Native
  ```sh
  bin/rubocop
  ```
OR

- Docker
  ```sh
  docker compose run --rm web bin/rubocop
  ```
