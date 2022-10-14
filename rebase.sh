#!/bin/bash
git config --global user.email "QA@tunex.io"
git config --global user.name "CI/CD"
git config pull.rebase true
git --version
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all
git pull --all
git branch --list "customer/*" > /tmp/branches.txt
cat /tmp/branches.txt
while read p; do
      git checkout "$p"
      if git rebase dev ; then 
      	git push -f ci HEAD:"$p"
      else 
	curl -X POST -H 'Content-type: application/json' --data '{"text":"Failed to automatically rebase branch '"https://gitlab.tunex.io/dev/mobidax/-/tree/$p"' \n Please rebase manually!"}' https://hooks.slack.com/services/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
	git rebase --abort
      fi
done < /tmp/branches.txt
rm /tmp/branches.txt
