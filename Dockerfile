FROM ruby:3.4.1

WORKDIR /app

COPY app/Gemfile* ./
RUN bundle install

COPY app /app

CMD ["sh", "-c", "sleep 10 && bundle exec puma -C puma.rb"]