#!/bin/sh

if [ -n "$3" ]; then
    RELS_TO_UPDATE=`basename "$3"`
else
    RELS_TO_UPDATE="`readlink current-release|tr -d /`"
fi
MIN_AGE=7
#DRY=echo
REPO_CHROOT_DIR=$BUILDER_DIR/chroot-debian

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-current-testing-repo-snapshot> [\"<component list>\" [<release-name>]]"
    exit 1
fi

if ! [ -d "$REPO_CHROOT_DIR" ]; then
    echo "Debian chroot $REPO_CHROOT_DIR does not exists"
    exit 1
fi

repo_snapshot_dir="$1"
components="$2"

touch -t `date -d "$MIN_AGE days ago" +%Y%m%d%H%M` age-compare-file

# $1 - snapshot file
# $2 - source dir
# $3 - destination dir
process_snapshot_file() {
    if ! [ -r $1 ]; then
        if [ "$VERBOSE" -ge 1 ]; then
            echo "Not existing snapshot, ignoring: `basename $1`"
        fi
        return
    fi
    if [ $1 -nt age-compare-file ]; then
        echo "Packages wasn't in current-testing for at least $MIN_AGE days, ignoring: `basename $1`"
        continue
    fi
    if [ -n "$DRY" ]; then
        sudo chroot $REPO_CHROOT_DIR su user -c "cd /tmp/qubes-apt-repo; reprepro listfilter $2 '`cat $1`'"
    fi
    $DRY sudo chroot $REPO_CHROOT_DIR su user -c "cd /tmp/qubes-apt-repo; reprepro copyfilter $3 $2 '`cat $1`'"
}

sudo umount $REPO_CHROOT_DIR/tmp/qubes-apt-repo $REPO_CHROOT_DIR/tmp/qubes-deb 2>/dev/null || true

for rel in $RELS_TO_UPDATE; do
    for pkg_set in dom0 vm; do
        sudo mount --bind $rel/$pkg_set $REPO_CHROOT_DIR/tmp/qubes-apt-repo 2>/dev/null || continue
        for dist in `ls $rel/current/$pkg_set`; do
            if [ -n "$components" ]; then
                for component in $components; do
                    process_snapshot_file $repo_snapshot_dir/current-testing-$pkg_set-$dist-$component \
                        $dist-testing $dist
                done
            else
                for snapshot_file in $repo_snapshot_dir/current-testing-$pkg_set-$dist-*; do
                    process_snapshot_file $snapshot_file \
                        $dist-testing $dist
                done
            fi
        done
        sudo umount $REPO_CHROOT_DIR/tmp/qubes-apt-repo
    done
    ./update_repo-current.sh $rel
done

rm -f age-compare-file

if [ "$AUTOMATIC_UPLOAD" = 1 ]; then
    `dirname $0`/sync_qubes-os.org_repo.sh "$3"
fi

echo Done.
