#!/bin/sh

[ -z "$REPOS_TO_UPDATE" ] && REPOS_TO_UPDATE="current-release/vm/dists/wheezy current-release/vm/dists/wheezy-testing current-release/vm/dists/jessie current-release/vm/dists/jessie-testing"

if [ -z "$GNUPG" ]; then
    GNUPG=gpg
fi

sign_release_file()
{
    if [ -n "$DEBIAN_SIGN_KEY" ]; then
        rm -f $1/Release.gpg
        rm -f $1/InRelease
        $GNUPG -abs -u "$DEBIAN_SIGN_KEY" \
            < $1/Release > $1/Release.gpg
        $GNUPG -a -s --clearsign -u "$DEBIAN_SIGN_KEY" \
            < $1/Release > $1/InRelease
    else
        echo "You need to set DEBIAN_SIGN_KEY variable" >&2
    fi
}

for repo in $REPOS_TO_UPDATE ; do
    echo "--> Processing repo: $repo..."
    sign_release_file $repo || exit 1
done
echo Done.
