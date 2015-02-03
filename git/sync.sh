#!/bin/bash

branch=$(git rev-parse --abbrev-ref head)

if [[ "$branch" == "master" ]]; then
  git pull upstream master && git push origin master
else
  git co master && git pull upstream master && git push origin master && git co $branch
fi
