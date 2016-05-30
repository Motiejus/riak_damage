all: .vagrant_up

ERLVER = 17.5
DISTRO = jessie
REL = riak-2.1.4-$(DISTRO)-$(ERLVER).tar.gz

BENCH = basho_bench/basho_bench

.vagrant_up: $(REL)
	vagrant up --provider=virtualbox
	touch $@

$(REL):
	docker build -t riak_release - < Dockerfile
	docker run -ti --rm -v `pwd`:/x riak_release

bench: basho_bench/basho_bench
	vagrant ssh -c "nohup /vagrant/firewall 120s 120s &"
	$(BENCH) riakc_pb.conf
	$(MAKE) $(MAKEFLAGS) -C basho_bench results
	@echo "Results generated. open basho_bench/tests/current/summary.png"

$(BENCH): basho_bench
	$(MAKE) $(MAKEFLAGS) -C basho_bench

basho_bench:
	git clone git://github.com/basho/basho_bench.git
	rm -fr basho_bench/tests
	ln -s ../tests basho_bench
