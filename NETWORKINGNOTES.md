## What is a Network?

A network is defined by an inteface, an IP address, a gateway and a subnet mask.

1. E.g. IP address 192.168.1.2
2. Subnet mask: 192.168.\*.\* (/16)
3. Gateway: 192.168.1.1

## What is a NAT?

NAT - network address translation is a type of firewall that rewrites the IP
address of packets sent to the gateway of the machine so they come out from
another interface on the router. And visa versa. So:
```
[LAN 1] <------------> [Router] <------------> [LAN 2] <----> [INTERNET]
            10.1.100.1/24   192.168.1.1/24
```
The router has two IP addresses as it has two interfaces. They are each on 
different networks. When it receives a packet from LAN 1 that is not destined
for LAN 1's network, it converts it to LAN 2, and sends it to its gateway on the
internet.

The firewall also rewrites packets on the way back so they appear to be from the
right IP address.

Double-NATed networks can cause problems because you cannot make a direct
connection without the network address translation. Ports have to be forwarded
by the firewall on the router to the right LAN. It is normally fine for outbound
traffic from the NATed LAN, LAN 1, but not inbound traffic from the internet to the
LAN. Because the machine on LAN 1 has no fixed IP address bar the gateway on LAN 2.

## What is DNS?

DNS is used to resolve domain names into IP addresses. Your ISP will have a
number of DNS servers you can use, and those are assigned by default. You can
also use public DNS servers, such as Google's DNS 8.8.8.8 or CloudFlare's DNS
1.1.1.1

Public DNS servers won't have any records of your internal network hostnames, so
if you want "davids-computer.davids-network.local" hostnames, then you're going
to have to have a DNS server on your internal network. 

DNS servers are easy to setup, a good choice is Pi-Hole which runs on a Raspberry Pi, 
and includes a constantly updated list of 'bad' domain names from spammers, malware 
etc, so provides some measure of protection.

A local DNS server will forward internet domain names to a public DNS server
such as mentioned before, and it will respond with IP addresses of the local DNS
entries it is setup for.

## What is a routing table?

A routing table entry consists of:

1. Network
2. Gateway
3. Interface IP
4. Routing Weight/Metric

* Network is a subnet mask of a network for example, 192.168.1.\* 24. Any traffic
to IP addresses in that network range will be managed by this routing rule.
* Gateway is the machine on that network to route traffic to that is destined
for that network, e.g. 192.168.1.5
* Interface is the network interface and local IP address for that interface.
* Metric is the 'weighting' traffic is given to favour this routing rule. When
there is more than one option to choose from for routing traffic, then the 
smaller number wins. So if you have an IP address accessible via two routes,
and one has a metric of 1 and the other 2, then 1 will be chosen first, unless
metric 1's interface is down.

It also specifies a 'default route' which is identifiable as a Network of a
subnet mask of '0.0.0.0' on the interface. It will have the lowest metric.
This is the route which is used for any traffic destined for any of the networks 
in the routing table. There will be a gateway specified which is typically another 
router with its own routing table. That other router will have a default route.. 
and so on. 

This is how traffic is handled on the internet, through routers passing on the 
traffic to their default route until there is a relevant entry in the routing table, 
or the  maximum number of hops is reached.

## Traceroute

To trace the life of a connection, you can use the network tool traceroute to
connect to a particular IP address. It will map out the routers that your
connection goes through before it arrives at its destination.

You can use this tool on different IP addresses to make sure your routing table 
is setup properly.



