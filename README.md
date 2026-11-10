# Qubes Linux deb repository (obsolete)

This repository is obsolete and no longer used.

It held the `reprepro` configuration and scripts for the Qubes OS Debian
package repository served at `deb.qubes-os.org`: signing the `Release` files,
moving packages from `current-testing` to `current`, and syncing to the server.
It was part of the legacy [qubes-builder](https://github.com/QubesOS/qubes-builder).

This is now done by the `publish_deb` plugin of
[qubes-builderv2](https://github.com/QubesOS/qubes-builderv2).
