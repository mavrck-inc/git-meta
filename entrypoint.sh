#!/bin/sh -l

echo "Hello World"

SHORT_BRANCH=${GITHUB_REF#refs/*/}
echo SHORT_BRANCH
SHORT_SHA=$(git rev-parse --short HEAD)
echo SHORT_SHA
echo "VERSION=$(if [ "$SHORT_BRANCH" = "main" ] || [ "$SHORT_BRANCH" = "master" ]; then echo `date '+%Y.%m.%d'`-$SHORT_SHA; else echo $SHORT_BRANCH-$SHORT_SHA; fi)" >> $GITHUB_ENV
