FROM ubuntu:trusty

RUN apt-get update && apt-get install -yq curl netcat && apt-get clean

WORKDIR /app

ADD test.sh /app/test.sh

CMD ["bash", "test.sh"]
