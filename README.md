# Gentoo images for software testing

You can find them on https://hub.docker.com/u/puchuu.

## Goal

GCC and Clang with sanitizers (where possible) for most popular platforms.

## Dependencies

- `"CONFIG_X86_X32=y"` in kernel config
- [docker cli](https://github.com/docker/cli)
- [buildah](https://github.com/containers/buildah)
- [bindfs](https://github.com/mpartel/bindfs)
- [qemu](https://github.com/qemu/qemu) `QEMU_USER_TARGETS="aarch64 aarch64_be arm armeb mips mipsel"`

## Build

Packages are building using qemu static user, compilation is heavy.
Recommended CPU is any modern one with >= `4 cores`.
Max required RAM ~ `2 GB` per core.

Please start `docker` and `qemu-binfmt` services.

Than allow other users in `/etc/fuse.conf`:

```
user_allow_other
```

Than add your local user to `/etc/subuid` and `/etc/subgid`:

```
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

- [sys-libs/glibc: MIPS/Linux inline syscall template is miscompiled](https://bugs.gentoo.org/708758)
- [sys-libs/glibc: different behaviour of LD_PRELOAD and LD_LIBRARY_PATH from error tolerance perspective](https://sourceware.org/bugzilla/show_bug.cgi?id=25341)
- [sys-libs/musl: does not support sysroot installation](https://bugs.gentoo.org/732482)
- [sys-libs/musl: undefined reference to __stack_chk_fail_local (x86)](https://www.openwall.com/lists/musl/2018/09/11/2)
- [sys-libs/musl profiles: add link time protection against DT_TEXTREL](https://bugs.gentoo.org/707660)
- [app-misc/ca-certificates: use 'doins' instead of 'cp -pPR' to workaround musl bug](https://bugs.gentoo.org/687236)
- [sys-devel/clang-runtime: feature request - musl support](https://github.com/google/sanitizers/issues/1080)
- [dev-lang/python: cross compilation using different libc is broken](https://bugs.gentoo.org/705970)
- [dev-lang/python: cross compiled python installs wrong version of lib2to3/Grammar pickle](https://bugs.gentoo.org/704816)
- [dev-lang/python: cross compiling of python modules with and without distutils](https://github.com/gentoo/gentoo/pull/9822)
- [sys-apps/sandbox: wrappers are broken when cross compiled using different libc](https://bugs.gentoo.org/706020)
- [sys-devel/flex: cross compilation fails, stage1flex segfault - pointer truncation by implicit declaration](https://bugs.gentoo.org/705800)
- [dev-libs/libgpg-error: cross compiling fails with "src/syscfg/lock-obj-pub.<tuple>.h': No such file or directory"](https://bugs.gentoo.org/584052)

- [bugzilla.kernel.org/show_bug.cgi?id=205957](https://bugzilla.kernel.org/show_bug.cgi?id=205957)
- [bugs.gentoo.org/651908](https://bugs.gentoo.org/651908)
- [bugs.gentoo.org/710786](https://bugs.gentoo.org/710786)
- [bugs.gentoo.org/711590](https://bugs.gentoo.org/711590)

## License

MIT
