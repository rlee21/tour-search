ARG BASE_RUBY_IMAGE_TAG="3.2.2-alpine"
FROM ruby:${BASE_RUBY_IMAGE_TAG} AS base

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV}

# m1 support
ARG TARGETARCH
RUN if [ "${TARGETARCH}" = "arm64" ]; then \
  apk add --no-cache \
  gcompat; \
  fi;

RUN apk add --no-cache \
  build-base \
  curl \
  git \
  postgresql-dev \
  postgresql-client \
  tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.22
RUN if [ "$RAILS_ENV" == "production" ]; then bundle config set --local without 'development test'; fi
RUN MAKE="make --jobs 5" bundle install --jobs=5 --no-cache --retry=5 && \
    bundle config unset rubygems.pkg.github.com

COPY . ./

CMD ["bundle", "exec", "rails", "server", "-p", "3000"]
