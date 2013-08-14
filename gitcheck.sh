#!/bin/bash

# ensure that all git directories are updated before wiping server

cd ~
for i in *; do
    if [[ -d $i/.git ]]; then
	cd $i;
	echo ::DIRECTORY $i::;
	git status;
	echo;
	cd ..;
    fi
done
