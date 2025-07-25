FROM ruby:3.3.2

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /usr/src/app

# Install bundler
RUN gem install bundler -v 2.4.22

# Copy gem files and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy app code
COPY . .

RUN chmod +x /usr/src/app/bin/order_created_listener

# Expose the Rails API port from the .env
EXPOSE ${RAILS_PORT:-3000}

# Run the Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]
