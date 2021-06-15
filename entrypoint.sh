#!/bin/sh -l

echo "Hello World"

BRANCH=${git rev-parse --abbrev-ref HEAD}
echo BRANCH
SHORT_SHA=$(git rev-parse --short HEAD)
echo SHORT_SHA
echo "VERSION=$(if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then echo `date '+%Y.%m.%d'`-$SHORT_SHA; else echo $BRANCH-$SHORT_SHA; fi)" >> $GITHUB_ENV
