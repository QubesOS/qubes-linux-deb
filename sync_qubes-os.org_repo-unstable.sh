#!/bin/sh

pushd `dirname $0`

#DRY="-n"
HOST=deb.qubes-os.org
HOST_BASEDIR=/pub/qubes/repo/deb
RELS_TO_SYNC="r2 r3.0"
if [ -n "$1" ]; then
    RELS_TO_SYNC="$1"
fi
REPOS_TO_SYNC="`for r in $RELS_TO_SYNC; do ls $r/vm/dists | grep unstable; done`"

for rel in $RELS_TO_SYNC; do
    rsync $DRY --partial --progress --hard-links -air $rel/vm/pool \
          $HOST:$HOST_BASEDIR/$rel/vm/
    for repo in $REPOS_TO_SYNC; do
        echo "Syncing $rel/vm/$repo..."
        rsync $DRY --partial --progress --hard-links -air $rel/vm/dists/$repo \
            $HOST:$HOST_BASEDIR/$rel/vm/dists/
    done

done

popd
