Riak games
----------

Breaking distributed riak on a single machine. Only Docker and Vagrant needed!

The Idea
--------

With `Linux Namespaces <https://lwn.net/Articles/580893/>`_ being a thing, we
can fully simulate an N-node Riak cluster on a single machine, having each node
its own ``iptables``/``tc`` rules. This repository exercises exactly that.

Plan for a 3-node cluster benchmark:

1. Execute reads/writes continuously with n=2, pr=1.
2. Block node3 (``iptables -j DROP``) from the rest of the nodes.
3. Expect no significant change in read/write throughput.

Results TBD.

How to
------

To create Vagrant VM with 3 Riak instances running, do the following
(pre-configured Vagrant and Docker are required)::

    make

At the end of the session (it takes ~15 minutes on my machine), you should see
the following output::

    ==> default: test created
    ==> default: WARNING: After activating test, nodes in this cluster
    ==> default: can no longer be downgraded to a version of Riak prior to 2.0
    ==> default: + netx 1 'riak1/bin/riak-admin bucket-type activate test'
    ==> default: + dst=1
    ==> default: + shift
    ==> default: + ip netns exec netns1 su vagrant -c 'riak1/bin/riak-admin bucket-type activate test'
    ==> default: test has been activated
    ==> default: WARNING: Nodes in this cluster can no longer be
    ==> default: downgraded to a version of Riak prior to 2.0

Now, you have riak-control running on `localhost:8098
<http://127.0.0.1:8098/admin>`, and ``riak-pb`` exposed on ``localhost:8087``.

Next Steps
----------

1. Run basho_bench successfully and produce meaningful results.
2. Implement "traffic blocking" for the inner-cluster, and recheck results.
