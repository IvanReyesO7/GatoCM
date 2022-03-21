FROM ruby:2.7.3

RUN apt-get update -qq && apt-get install -y build-essential\
                                             libpq-dev      \
                                             nodejs         \
                                             curl           \
                                             sudo

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt install -y nodejs
RUN npm install --global yarn

RUN mkdir /api
WORKDIR /api

COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

RUN gem install bundler:2.2.26
RUN bundle install
RUN yarn install

COPY . /api
