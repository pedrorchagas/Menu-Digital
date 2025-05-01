FROM ruby

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY .

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]