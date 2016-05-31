# Add br0
init() {
    brctl addbr br0
    ip addr add 10.99.88.254/24 dev br0
    ip link set br0 up
}

# Bootstrap $1'th netns, add to br0. See https://lwn.net/Articles/580893/
add_netns() {
    ip netns add netns${1}
    ip netns exec netns${1} ip link set dev lo up

    ip link add veth${1}a type veth peer name veth${1}b
    ip link set veth${1}a up
    ip link set veth${1}b netns netns${1}

    ip netns exec netns${1} ip addr add 10.99.88.${1}/24 dev veth${1}b
    ip netns exec netns${1} ip link set veth${1}b up

    brctl addif br0 veth${1}a
}

# Utility to execute a given command in a network namespace for vagrant user
netx() {
    dst=$1
    shift
    ip netns exec netns${dst} su vagrant -c "$@"
}

# Forward incoming tcp port $2 to $1:$2
forward_port() {
    nohup socat tcp-listen:$2,fork,reuseaddr tcp-connect:$1:$2 &
}

start_riak() {
    netx $1 "riak${1}/bin/riak start"
}

# Join ${1}'th node to 1
join_riak() {
    netx $1 "riak${1}/bin/riak-admin cluster join riak@10.99.88.1"
}

join_riak_commit() {
    netx 1 "riak1/bin/riak-admin cluster plan"
    netx 1 "riak1/bin/riak-admin cluster commit"
}

# set n_val for bucket named <<"test">> (default in basho_bench)
prepare_bucket() {
    netx 1 "riak1/bin/riak-admin bucket-type create test \
        '{\"props\":{\"n_val\":2, \"pr\": 1, \"w\": 1, \"dw\": 1}}'"
    netx 1 "riak1/bin/riak-admin bucket-type activate test"
}
