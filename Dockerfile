FROM debian:jessie

ENV ERLVER 17.5

RUN apt-get update
RUN apt-get install -y curl wget git
RUN apt-get install -y build-essential ncurses-dev libssl-dev libpam0g-dev

RUN wget http://erlang.org/download/otp_src_$ERLVER.tar.gz
RUN tar -xzf otp_src_$ERLVER.tar.gz
RUN cd otp_src_$ERLVER; ./configure
RUN cd otp_src_$ERLVER; make -j8
RUN cd otp_src_$ERLVER; make install

RUN git clone git://github.com/basho/riak -b riak-2.1.4
RUN make -C riak deps
RUN make -C riak rel
RUN tar -czf riak-2.1.4-jessie-$ERLVER.tar.gz -C /riak/rel riak

CMD cp riak-2.1.4-jessie-$ERLVER.tar.gz /x
