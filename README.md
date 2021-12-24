## Api Console Manager
This a small personal project, the idea is to create a centralized and easy to visualize api console manager.
Something similar to a CMS, but with more flexible endpoints and the ability to create objects through the terminal with no need to use the UI.

## How to contribute

For consistency purposes, add your name/nickname to the start of the name of your branch followed by a keyword of the feature you are developing.

For instance:
`ivan-add-app-controller`
`emanuel-updated-list-view`

Please name your branches and your commits in English, as well as your reviews and comments.

Avoid merging your own Pull Requests, please make sure that someone else reviews and merges them.

Before making a Pull Request use `git status` or `git diff` to check that you are only pushing what you are changing.

Thank you so much for contributing to this project 🙏🏽.

## For occasional developers

You can contribute to this project without having to install all the dependencies in your computer (Gems and Yarn packages),
you can set a docker container that will isolate the development enviornment of this application,
you only need to install docker, follow the steps below, and you are all set.

## Install Docker

Choose your OS and install the desktop version of Docker.
You should read this website and follow the directions:
[https://docs.docker.com/desktop/](https://docs.docker.com/desktop/).

If you install the OSX version, this installer includes `docker-compose` which this app uses to bring up
multiple containers, in our case we need one for our rails app and other one for Postgre.

If you are not using OSX, you'll need to figure out the best to install
`docker`, `docker-compose`, and the dependencies for your system.

## Building the base rails image

You can build the base api_console image by running the following command:

```
docker-compose build api_console
```

Anytime you add a RubyGem to Gemfile or a node package to package.json, you
will need to re-run this command.

## Initializing the app for the first time

To bring up the app for the first time you need to first initialize the database.

You can do this by running the following command **warning resets db**:

```
docker-compose run api_console bundle exec rake db:reset db:migrate 
```

If you get the error "Your Yarn packages are out of date!",
run the following command before trying the command above again:

```
docker-compose run api_console bundle exec yarn install --check-files
```

## Updating migrations

```
docker-compose run api_console bundle exec rake db:migrate
```

## Populating the db
⚠️ This will reset your database

```
docker-compose run api_console bundle exec rake db:drop db:create db:migrate db:seed
```

## Launching the rails console

```
docker-compose run api_console rails console
```

## Bringing the app up

To bring the app up, run:

```
docker-compose up
```

Once the app is up, you should be able to visit the site in your browser at
localhost:3000. You may need to wait a few seconds for the app to start.


## Bringing the app down

To bring the app down, run:

```
docker-compose down
```

Or press CTRL-C in the terminal where it is running.

## Runing the Rspecs

To run the rspecs, run:

```
docker-compose run api_console bundle exec rspec  
```

