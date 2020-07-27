# base/php-apache

Base docker image for docker apache mod-php.

This is a work in progress for now. Will get cleaned up over time.


## TODO
- Consider using www-data user in prod context but php user in dev context.
  Using that user id 1000 helps in dev, and not using root is a good idea too.
  (see upcoming usage example)

### Write tests

#### Web tests
- Run web container test as php user, since we don't expect much issues from root.
- test a non existing web endpoint
- test existing web endpoint
- test endpoint that writes session data
- test endpoint that tries to write to / folder
- test executing privileged shell command

#### Cli
- test workdir
- test composer in path
- test some of the dockerfile stuff (to be defined)

#### Dev
- we could build a 2nd web-dev container and run dev specific tests there.
- an xdebug test could be done but not as relevant since no network issues expected.
- opcache not caching file changes in dev context is maybe doable
