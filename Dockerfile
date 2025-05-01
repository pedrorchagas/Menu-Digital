FROM ruby

WORKDIR /app

COPY app/Gemfile* ./
RUN bundle install

COPY app .

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]