# Gentoo images for software testing

You can find them on https://hub.docker.com/u/puchuu.

## Goal

GCC and Clang with sanitizers (where possible) for most popular platforms.

## Dependencies

- `"CONFIG_X86_X32=y"` in kernel config
- docker
- buildah
- qemu `QEMU_USER_TARGETS="aarch64 aarch64_be arm armeb mips64 mips64el mips mipsel"`

## Build

Packages are building using qemu static user, compilation is heavy.
Recommended CPU is any modern one with >= 16 cores.
Max required RAM ~ 2 GB per core.

Please start `docker` and `qemu-binfmt` services.

Than add your local user to `/etc/subuid` and `/etc/subgid`:

```sh
my_user:100000:65536
```

Please ensure that your local user is in `docker` group.

Than open [`env.sh`](env.sh) and update variables.

```sh
./build.sh
./push.sh
./pull.sh
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
- [bugs.gentoo.org/704816](https://bugs.gentoo.org/704816)
- [bugs.launchpad.net/qemu/+bug/1858461](https://bugs.launchpad.net/qemu/+bug/1858461)
- [bugs.gentoo.org/645626](https://bugs.gentoo.org/645626)
- [bugs.gentoo.org/705800](https://bugs.gentoo.org/705800)
- [bugs.gentoo.org/705970](https://bugs.gentoo.org/705970)
- [bugs.gentoo.org/706020](https://bugs.gentoo.org/706020)
- [bugs.gentoo.org/687236](https://bugs.gentoo.org/687236)
- [bugs.gentoo.org/687234](https://bugs.gentoo.org/687234)
- [bugs.gentoo.org/604590](https://bugs.gentoo.org/604590)
- [github.com/google/sanitizers/issues/1080](https://github.com/google/sanitizers/issues/1080)
- [bugs.gentoo.org/706210](https://bugs.gentoo.org/706210)
- [github.com/openssl/openssl/issues/10948](https://github.com/openssl/openssl/issues/10948)
- [bugs.gentoo.org/707332](https://bugs.gentoo.org/707332)
- [bugs.gentoo.org/707660](https://bugs.gentoo.org/707660)
- [bugs.gentoo.org/651908](https://bugs.gentoo.org/651908)
- [github.com/containers/buildah/issues/2165](https://github.com/containers/buildah/issues/2165)
- [gitlab.com/gnutls/gnutls/issues/941](https://gitlab.com/gnutls/gnutls/issues/941)
- [bugs.gentoo.org/710122](https://bugs.gentoo.org/710122)
- [bugs.gentoo.org/710786](https://bugs.gentoo.org/710786)
- [bugs.gentoo.org/711590](https://bugs.gentoo.org/711590)
- [bugs.gentoo.org/708758](https://bugs.gentoo.org/708758)

## License

MIT
