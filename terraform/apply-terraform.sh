#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

git checkout master
git pull
git reset --hard HEAD


terraform init
terraform apply -auto-approve