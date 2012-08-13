eurucamp-activities
===================

Configuration
-------------

### Basic setup

* install ruby 1.9.3 (mongoid ...)
* `gem install bundler --pre`
* configure MongoDB in `config/mongoid.yml`

Next two steps are not mandatory.

* configure Twitter account in `config/application.yml`
* configure tokens in `config/application.yml`

If you haven't changed anything:

* fake Eurucamp Twitter account is [@Eactivitiestest](https://twitter.com/Eactivitiestest)
* you can debug stuff using this [page](https://twitter.com/#!/search/realtime/%23imin%20OR%20%23imout%20to%3Aeactivitiestest)
* message format is `<ACCOUNT> <TOKEN> <EVENT/ACTIVITY CODE>`, for example: `@Eactivitiestest #imin DKN` means: `i'm participating in drinkup`

### Activities

Activities can be configured in `config/application.yml`. The format is:

```YAML
activities:
-
  name: "Football game"
  code: "FTB"
  when: 2012-08-17 20:00:00 +0100
  where: "Blah"
-
  name: "Drinkup"
  code: "DRN"
  when: 2012-08-18 20:00:00 +0100
  where: "Blah"
```

Running
-------

* `mongod`
* `bundle exec rackup`

We don't use worker in local setup. Instead, application fetches latest statuses in each request.


