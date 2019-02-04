
FROM ruby:2.5

LABEL Name=danielhabenicht.github.io Version=0.0.1
EXPOSE 4000

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /app
COPY . /app

COPY Gemfile ./
RUN bundle install

CMD jekyll serve --host 0.0.0.0
