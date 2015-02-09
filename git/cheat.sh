#!/bin/bash

echo -e "git open\t\tstart a new branch"
echo -e "git cm \"msg\"\t\tcommit all changes"
echo -e "git pr\t\t\tupdate master, rebase, open pull request"
echo -e "git prr\t\t\topen pull request list in browser"
echo -e "git close [br]\t\tsync merged pull request and delete branch"
echo -e "git cs\t\t\tci-status for current branch pull request"
echo -e "git css\t\t\topen jenkins log in browser"
echo
echo -e "git br\t\t\tlist branches"
echo -e "git df\t\t\tshow current diff"
echo -e "git dfl\t\t\tshow diff for last commit"
echo -e "git dfr <cmt> [cmt]\tshow diff for single commit or between commits"
echo -e "git lg\t\t\tshow last 10 commits"
echo -e "git lgg\t\t\tshow full commit history"
echo -e "git st\t\t\tgit status"
echo
echo -e "git in [rmt] [br]\tshow incoming commits for a remote/branch"
echo -e "git out [rmt]\t\tshow outgoing commits for a remote"
echo -e "git pending [rmt|all]\tshow pending commits for a remote"
echo -e "git revert <file>\tundo changes to a file"
echo -e "git rollback\t\tundo the last commit"
echo -e "git sync\t\tupdate local+origin/master from upstream"
echo
echo -e "optional remote for in/out defaults to origin"
echo -e "optional remote for pending picks: upstream, origin"
echo -e "optional branch defaults to current unless on master"
echo
