# Gentoo images for software testing

You can find them on https://hub.docker.com/u/puchuu.

## Goal

GCC and Clang (where possible) with sanitizers for most popular platforms.

## Dependencies

- docker
- buildah
- qemu `QEMU_USER_TARGETS="aarch64 aarch64_be arm armeb mips mips64 mips64el mipsel"`

## Build

Packages are building using qemu static user, compilation is heavy.
Recommended CPU is any modern one with >= 16 cores.

Please start `docker` and `qemu-binfmt` services.

Than add your local user to `/etc/subuid` and `/etc/subgid`:

```sh
my_user:100000:65536
```

Please ensure that your local user is in `docker` group.

Than open [`env.sh`](env.sh) and update variables.

```sh
./build.sh
```

Build is rootless, just use your regular `my_user`.

## Cross build

```
+-------------------------+
|                         |
|           +-----------+ |              +-----------+
|           |           | |              |           |
| native    | cross     | |    export    | cross     |
| container | container | | +----------> | container |
|           |           | |              | (+ qemu)  |
|           +-----------+ |              |           |
|                         |              +-----------+
+-------------------------+
```

Native container creates minimal cross image, adds `qemu`, exports it and rebuilds everything.

## Related bugs

- [github.com/gentoo/gentoo/pull/9822](https://github.com/gentoo/gentoo/pull/9822)
- [bugzilla.kernel.org/show_bug.cgi?id=205957](https://bugzilla.kernel.org/show_bug.cgi?id=205957)
- [bugs.gentoo.org/666560](https://bugs.gentoo.org/666560)
- [bugs.gentoo.org/584052](https://bugs.gentoo.org/584052)
- [sourceware.org/bugzilla/show_bug.cgi?id=25341](https://sourceware.org/bugzilla/show_bug.cgi?id=25341)

## License

MIT
