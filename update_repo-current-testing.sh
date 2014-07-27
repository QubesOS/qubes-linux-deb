#!/bin/sh

REPOS_TO_UPDATE="current-release/vm/dists/*-testing"

. `dirname $0`/update_repo.sh

if [ "$AUTOMATIC_UPLOAD" = 1 ]; then
    `dirname $0`/sync_qubes-os.org_repo.sh
fi
