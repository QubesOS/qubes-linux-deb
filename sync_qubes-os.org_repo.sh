#!/bin/sh

pushd `dirname $0`

#DRY="-n"
USERNAME=marmarek
HOST=yum.qubes-os.org
RELS_TO_SYNC="r2 r3"
REPOS_TO_SYNC="jessie jessie-testing wheezy wheezy-testing"

for rel in $RELS_TO_SYNC; do
    rsync $DRY --partial --progress --hard-links -air $rel/vm/pool \
          $USERNAME@$HOST:/var/www/deb.qubes-os.org/$rel/vm/
    for repo in $REPOS_TO_SYNC; do
        echo "Syncing $rel/vm/$repo..."
        rsync $DRY --partial --progress --hard-links -air $rel/vm/dists/$repo \
            $USERNAME@$HOST:/var/www/deb.qubes-os.org/$rel/vm/dists/
    done

done

popd
