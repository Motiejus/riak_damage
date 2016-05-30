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

Requirements
------------

Vagrant and Docker.
