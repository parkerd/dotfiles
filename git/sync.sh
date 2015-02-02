#!/bin/bash

branch=$(git rev-parse --abbrev-ref head)

git co master && git pull upstream master && git push origin master && git co $branch
