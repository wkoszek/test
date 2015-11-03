#!/bin/sh

set -x

(
	date
	./simple.sh
) > output.html

if [ $? -eq 0 ]; then
	sh -i -c ssh-agent > env-set
	. ./env-set
	chmod 600 deploy
	ssh-add deploy

	git config --global user.email "travis@koszek.com"
	git config --global user.name "Travis"

	mkdir tmp
	cd tmp
	git clone git@github.com:wkoszek/test.git
	cd test

	BRANCH=$RANDOM

	git checkout -B $BRANCH
	git branch --set-upstream-to origin/$BRANCH

	mv ../../output.html .

	git add output.html
	git commit -m "New stuff `date`" output.html
	git push origin gh-pages
fi
