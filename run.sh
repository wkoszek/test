#!/bin/sh

set -x

(
	date
	./simple.sh
) > output.html

if [ $? -eq 0 ]; then
	sh -i -c ssh-agent > env-set
	. ./env-set
	ssh-add deploy
	mkdir tmp
	cd tmp
	git clone git@github.com:wkoszek/test.git
	cd test
	git checkout -B gh-pages
	mv ../../output.html .
	git add output.html
	git commit -m "New stuff `date`" output.html
	git push origin gh-pages
fi
