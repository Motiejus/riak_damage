FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl wget git
RUN apt-get install -y build-essential ncurses-dev libssl-dev

RUN wget https://raw.githubusercontent.com/kerl/kerl/master/kerl \
    -O /usr/bin/kerl
RUN chmod a+x /usr/bin/kerl

RUN MAKEFLAGS=-j4 kerl build 17.5 17.5
RUN kerl install 17.5 /usr/local/17.5
RUN rsync -a /usr/local/17.5/ /usr/local

RUN git clone git://github.com/basho/riak -b riak-2.1.4
RUN make -C riak deps
RUN apt-get install -y libpam0g-dev
RUN make -C riak rel
RUN tar -czf riak-2.1.4.rel.tar.gz -C /riak/rel riak

CMD cp riak-2.1.4.rel.tar.gz /x
