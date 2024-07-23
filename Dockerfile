# Use an argument for Ruby version
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim

# Set the working directory
WORKDIR /app

# Set environment variables
ENV RAILS_ENV="development"
ENV BUNDLE_PATH="/usr/local/bundle"
ENV EDITOR="nano"

# Install packages needed to build gems and nano editor
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libvips pkg-config nano && \
    rm -rf /var/lib/apt/lists/*

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
