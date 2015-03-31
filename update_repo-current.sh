#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 <qubes-release>" >&2
    exit 1
fi

REPOS_TO_UPDATE="$1/vm/dists/jessie $1/vm/dists/wheezy"

. `dirname $0`/update_repo.sh
