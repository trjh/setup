#!/bin/bash

# ensure that all git directories are updated before wiping server

cd ~
for i in *; do
    cd $i;
    echo $i;
    git status;
    echo;
    cd ..;
done
