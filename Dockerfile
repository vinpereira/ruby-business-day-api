FROM ruby:2.4.1

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install --without development test

EXPOSE 9292

CMD ["puma", "-e", "production"]
