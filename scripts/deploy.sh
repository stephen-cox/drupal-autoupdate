#!/bin/bash

#
# Finalise the hotfix and deploy to live
#

ALIAS=$1

echo "
##
# [Task] Finalising git hotfix branch
##
"

# Check git branch
cd ${WORKSPACE}
BRANCH=$(git symbolic-ref --short -q HEAD)
if [[ ! "${BRANCH}"  =~ ^hotfix.* ]]; then
  echo "
##
# [Error] Git is not a on a hotfix branch
##
"
  exit 1
fi

# Finalise hotfix
git checkout develop
git merge --no-ff ${BRANCH}
git checkout master
git merge --no-ff ${BRANCH}
git branch -d ${BRANCH}
git push origin --delete ${BRANCH}
git push origin master
git push origin develop

# Deploy changes live
echo "
##
# [Task] Deploying ${ALIAS} to live environment
##
"
drush @${ALIAS}.live ssh git pull origin master || { exit 1; }
drush @${ALIAS}.live updb --yes
