# Gentoo images for software testing.

You can find them on https://hub.docker.com/u/puchuu.

## Build

Packages are building using qemu static user, compilation is heavy.
Recommended CPU is any modern one with >= 8 cores.

Please add your local user to `/etc/subuid` and `/etc/subgid`:

```sh
my_user:100000:65536
```

Please ensure that your local user is in `docker` group.

Than open [`env.sh`](env.sh) and update variables.

```sh
source ./env.sh
./build.sh
```

## License

MIT
