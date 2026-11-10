# Qubes Debian Repository Tools

Scripts and `reprepro` configuration for maintaining and publishing the
Qubes OS Debian (`.deb`) package repository served at `deb.qubes-os.org`. This
is part of the [Qubes OS](https://www.qubes-os.org) build and release
infrastructure, not something installed in a qube.

For each Qubes release (`r4.0`, `r4.1`, ...) and Debian suite (buster,
bullseye, bookworm, ...) the repository is split into `current`,
`current-testing`, `security-testing`, and `unstable`. The `reprepro`
configuration for each lives under `<release>/vm/conf/`.

## What the scripts do

- `update_repo*.sh` — sign the `Release` files (needs `DEBIAN_SIGN_KEY`) for a
  given repository.
- `commit-testing-to-current.sh` — promote packages that have spent at least
  7 days in `current-testing` into `current`.
- `sync_qubes-os.org_repo*.sh` — `rsync` the built repository to the
  `deb.qubes-os.org` host.
