#!/bin/bash

if [ -z $1 ]; then
  echo "usage: $0 <commit> [commit]"
fi

commit1=$1
commit2=$2

if [ -z $commit2 ]; then
  git --no-pager diff $commit1~1 $commit1
else
  git --no-pager diff $commit1 $commit2
fi
