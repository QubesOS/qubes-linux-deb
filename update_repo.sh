#!/bin/sh

[ -z "$REPOS_TO_UPDATE" ] && REPOS_TO_UPDATE="current-release/vm/dists/wheezy current-release/vm/dists/wheezy-testing current-release/vm/dists/jessie current-release/vm/dists/jessie-testing"

sign_release_file()
{
    if [ -n "$DEBIAN_SIGN_KEY" ]; then
        rm -f $1/Release.gpg
        gpg -abs -u "$DEBIAN_SIGN_KEY" \
            -o $1/Release.gpg \
            $1/Release
    else
        echo "You need to set DEBIAN_SIGN_KEY variable" >&2
    fi
}

for repo in $REPOS_TO_UPDATE ; do
    echo "--> Processing repo: $repo..."
    sign_release_file $repo || exit 1
done
echo Done.
