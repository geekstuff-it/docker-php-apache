# base/php-apache

base docker image for docker apache mod-php

## tag
base/php-apache

## build example
```
docker build -t base/php-apache:latest -t base/php-apache:x.y.z .
```

## build and bash into it
```
docker build -t base/php-apache:wip . && docker run -name php-apache-wip -rm -it base/php-apache:wip bash
```
