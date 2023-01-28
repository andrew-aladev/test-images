# Gentoo images for software testing

You can find them on https://hub.docker.com/u/puchuu.

## Goal

[GCC](https://gcc.gnu.org) and [Clang](https://clang.llvm.org) with sanitizers (where possible) for required platforms.

## Dependencies

- [buildah](https://github.com/containers/buildah)

## Build

Please add your local user to `/etc/subuid` and `/etc/subgid`:

```
my_user:100000:65536
```

Than open [`env.sh`](env.sh) and update variables.

```sh
./build.sh
./push.sh
./pull.sh
```

Build is rootless, just use your regular `my_user`.

## License

MIT license, see [LICENSE](LICENSE) and [AUTHORS](AUTHORS).
