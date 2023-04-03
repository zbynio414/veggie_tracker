FROM ruby:2.5-alpine

RUN apk update && apk upgrade 
RUN apk add --no-cache build-base sqlite~=3.34.1-r0 sqlite-dev sqlite-libs --update make
RUN apk add --upgrade postgresql-dev

WORKDIR /usr/src/app

COPY Gemfile* .

RUN gem install bundler -v 1.16.6
RUN gem install bcrypt -v 3.1.12
RUN gem install pg 
RUN bundle install

COPY . .
 
RUN bundle exec rake db:migrate

EXPOSE 9393

CMD ["shotgun"]
