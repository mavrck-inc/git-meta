#!/bin/sh -l

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

echo "VERSION=$(if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then echo `date '+%Y.%m.%d'`-$SHORT_SHA; else echo $BRANCH-$SHORT_SHA; fi)" >> $GITHUB_ENV

echo "authorName=$AUTHOR" > /tmp/meta
echo "authorEmail=$AUTHOR_EMAIL" >> /tmp/meta
echo "headRef=$WEBHOOK_HEAD_REF" >> /tmp/meta
echo "commit=$COMMIT" >> /tmp/meta
echo "message=$(echo $MESSAGE | tr '\n' ' ' )" >> /tmp/meta

cat /tmp/meta
