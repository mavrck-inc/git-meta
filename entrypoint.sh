#!/bin/sh -l

META_FILE_PATH=$1

BRANCH=$(git rev-parse --abbrev-ref HEAD)
SHORT_SHA=$(git rev-parse --short HEAD)
MESSAGE=$(git log -1 --pretty=%B)
AUTHOR_EMAIL="$(git log -1 --pretty=%ae)"
COMMIT="$(git log -1 --pretty=%H)"
AUTHOR="$(git log -1 --pretty=%an)"

if [ "$WEBHOOK_HEAD_REF" = "" ]; then
    export WEBHOOK_HEAD_REF="$(git symbolic-ref HEAD --short 2>/dev/null)"
else
    export WEBHOOK_HEAD_REF="${WEBHOOK_HEAD_REF:11}"
fi

if [ "$WEBHOOK_HEAD_REF" = "" ] ; then
  WEBHOOK_HEAD_REF="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export WEBHOOK_HEAD_REF=${WEBHOOK_HEAD_REF#remotes/origin/};
fi

ESCAPED_BRANCH=$(echo $BRANCH | sed 's/[^a-zA-Z0-9]/_/g')
VERSION_DATE=$(date '+%Y.%m.%d.%s');

VERSION=$(if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then echo $VERSION_DATE-$SHORT_SHA; else echo $ESCAPED_BRANCH-$VERSION_DATE-$SHORT_SHA; fi)

echo "VERSION=$VERSION" >> $GITHUB_ENV
echo "VERSION=$VERSION" >> $GITHUB_OUTPUT
echo "Writing to $META_FILE_PATH"

echo "authorName=$AUTHOR" > $META_FILE_PATH
echo "authorEmail=$AUTHOR_EMAIL" >> $META_FILE_PATH
echo "headRef=$WEBHOOK_HEAD_REF" >> $META_FILE_PATH
echo "commit=$COMMIT" >> $META_FILE_PATH
echo "message=$(echo $MESSAGE | tr '\n' ' ' )" >> $META_FILE_PATH
