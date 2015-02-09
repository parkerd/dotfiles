#!/bin/bash

check_remote() {
  remote=$1
  incoming=$(git in $remote 2>&1)
  outgoing=$(git out $remote 2>&1)

  if [ -n "$incoming" -o -n "$outgoing" ]; then
    echo "$remote:"
  fi

  if [ -n "$incoming" ]; then
    echo "  incoming:"
    git in $remote
  fi

  if [ -n "$outgoing" ]; then
    echo "  outgoing:"
    git out $remote
  fi

  echo
}

if [ -z $1 ]; then
  remote=upstream
  if [ "$(git remote | grep -c upstream)" -lt 1 ];then
    remote=origin
  fi
else
  remote=$1
fi

if [[ "$remote" == "all" ]]; then
  for remote in $(git remote); do
    check_remote $remote
  done
else
  check_remote $remote
fi
