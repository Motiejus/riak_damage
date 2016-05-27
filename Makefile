all: .vagrant_up

ERLVER = 17.5

.vagrant_up: riak-2.1.4-$(ERLVER).tar.gz
	vagrant up --provider=virtualbox
	touch $@

riak-2.1.4-$(ERLVER).tar.gz:
	docker build -t riak_release - < Dockerfile
	docker run -ti --rm -v `pwd`:/x riak_release
