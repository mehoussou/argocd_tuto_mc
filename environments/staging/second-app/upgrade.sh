#!/bin/bash

#exit when any cmd fails
set -e

new_ver=$1

echo "new version: $new_ver"

#simulate release of the new docker images
docker tag nginx:1.23.3 codehubrepo/nginx:$new_ver

#push new version to dockerhub
docker push codehubrepo/nginx:$new_ver

# create tmp folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

#clone Github repo
git clone https://github.com/mehoussou/argocd_tuto_mc.git $tmp_dir

#update image tag
sed -i '' -e "s/codehubrepo\/nginx:.*/codehubrepo\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml

#commit and push
cd $tmp_dir
git add .
git commit -m "update image to $new_ver"
git push

#Optionally on build agents - remove folder
rm -rf $tmp_dir
