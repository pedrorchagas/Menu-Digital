FROM ruby:3.4.1

WORKDIR /app

COPY app/Gemfile* ./
RUN bundle install

COPY app .

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]