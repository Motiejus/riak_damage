all: .vagrant_up

ERLVER = 17.5
DISTRO = jessie
REL = riak-2.1.4-$(DISTRO)-$(ERLVER).tar.gz

.vagrant_up: $(REL)
	vagrant up --provider=virtualbox
	touch $@

$(REL):
	docker build -t riak_release - < Dockerfile
	docker run -ti --rm -v `pwd`:/x riak_release
