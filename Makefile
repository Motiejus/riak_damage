all: .vagrant_up

.vagrant_up: riak-2.1.4.rel.tar.gz
	vagrant up --provider=virtualbox
	touch $@

riak-2.1.4.rel.tar.gz:
	docker build -t riak_release - < Dockerfile
	docker run -ti --rm -v `pwd`:/x riak_release
