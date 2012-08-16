eurucamp-activities
===================

Configuration
-------------

### Basic setup

* install ruby 1.9.3 (mongoid ...)
* `gem install bundler --pre`
* configure MongoDB in `config/mongoid.yml`
* run `bundle exec rake db:mongoid:create_indexes`
* run `bundle exec rake db:seed` (this will create fake admin account)

Next two steps are not mandatory.

* configure Twitter account in `config/application.yml`
* configure tokens in `config/application.yml`

If you haven't changed anything:

* fake Eurucamp Twitter account is [@Eactivitiestest](https://twitter.com/Eactivitiestest)
* you can debug stuff using this [page](https://twitter.com/#!/search/realtime/%23imin%20OR%20%23imout%20to%3Aeactivitiestest)
* message format is `<ACCOUNT> <TOKEN> <EVENT/ACTIVITY CODE>`, for example: `@Eactivitiestest #imin DKN` means: `i'm participating in drinkup`
* admin panel is mounted at `/admin` (default: `info+activities@fake.com` / `dontuseinproduction` )

You still need to set ENV variables if you want to post to Twitter (worker)

### Activities

Activities can be configured in admin panel.

Running
-------

* `mongod`
* `bundle exec rackup`

We don't use worker in local setup. Instead, application fetches latest statuses in each request.

Admin panel
------------

* visit `/admin` and provide email / password

