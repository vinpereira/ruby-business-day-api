[![Build Status](https://travis-ci.org/vinpereira/ruby-business-day-api.svg?branch=mongodb)](https://travis-ci.org/vinpereira/ruby-business-day-api)
[![Dependency Status](https://gemnasium.com/badges/github.com/vinpereira/ruby-business-day-api.svg)](https://gemnasium.com/github.com/vinpereira/ruby-business-day-api)

# Ruby/Sinatra Business Day API


## Programming Language, Docker and Docker Compose version, and libraries used to solve the problems

  - Ruby 2.4.1
  - Docker 17.06.0-ce
  - Docker Compose 1.14.0

Main libraries:
- httparty        ~>0.15.5
- libxml-ruby     ~>3.0.0
- mongoid         ~>6.2.0
- puma            ~>3.9.1
- rspec           ~>3.6.0
- shotgun         ~>0.9.2
- sinatra         ~>2.0.0
- sinatra-contrib ~>2.0.0

### Running the code with Docker Compose
- Clone this repository and access its root folder

- Run Docker Compose (re)start a container
  - If there is no image available (or it is the first time) then Docker Compose will build the image
```sh
$ docker-compose up
```
