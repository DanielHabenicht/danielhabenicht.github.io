---
layout: post
title: "How to configure Docker to use certain network ranges"
date: 2018-10-31T17:38:39
categories: [Docker]
tags: [docker]
slug: configure-docker-for-certain-network-ranges
---

In order to configure Docker to use a certain network range just paste this into your `/etc/docker/daemon.json`.

<!--more-->

```json
{
  "default-address-pools": [{ "base": "192.168.199.0/24", "size": 28 }]
}
```

It configures Docker to use the address space from `192.168.199.0` to `192.168.199.255` in blocks of 16 addresses each.
This means the `docker0` network gets created like this:

```bash
# ip a
64: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:2c:a9:5e:96 brd ff:ff:ff:ff:ff:ff
    inet 192.168.199.1/28 brd 192.168.199.15 scope global docker0
       valid_lft forever preferred_lft forever
```

and all other bridge networks in the same way:

```bash
# ip a
65: br-fc09df0ee651: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:3d:0c:57:b3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.199.17/28 brd 192.168.199.31 scope global br-fc09df0ee651
       valid_lft forever preferred_lft forever
```

Here you have the [CIDR notation][1] for reference.

[1]: https://de.wikipedia.org/wiki/Classless_Inter-Domain_Routing#%C3%9Cbersicht_f%C3%BCr_IPv4
