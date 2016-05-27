FROM debian:jessie

ENV ERLVER 17.5

RUN apt-get update
RUN apt-get install -y curl wget git libpam0g-dev
RUN apt-get install -y build-essential ncurses-dev libssl-dev

RUN wget https://raw.githubusercontent.com/kerl/kerl/master/kerl \
    -O /usr/bin/kerl
RUN chmod a+x /usr/bin/kerl

RUN MAKEFLAGS=-j8 kerl build $ERLVER $ERLVER
RUN kerl install $ERLVER /$ERLVER

RUN git clone git://github.com/basho/riak -b riak-2.1.4
RUN . /$ERLVER/activate && make -C riak deps
RUN . /$ERLVER/activate && make -C riak rel
RUN tar -czf riak-2.1.4-$ERLVER.tar.gz -C /riak/rel riak

CMD cp riak-2.1.4-$ERLVER.tar.gz /x
