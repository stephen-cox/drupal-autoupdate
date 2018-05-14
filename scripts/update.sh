#!/bin/bash

#
# Check for and apply any security updates
#

ALIAS=$1
DATE=$(date +"%Y-%m-%d")

# Check for updates
echo "
##
# [Task] Checking for updates
##
"
cd ${WORKSPACE}/web
drush pm:security --field=name > /tmp/updates.txt

# Install any security updates
if [ -s /tmp/updates.txt ]; then

  cd ${WORKSPACE}
  git checkout -b hotfix/auto-${DATE}

  while read UPDATE || [[ -n $UPDATE ]]; do

    echo "
##
# [Task] Installing update for ${UPDATE}
##
"
    cd ${WORKSPACE}
    composer update ${UPDATE} --with-dependencies
    git add -A :/
    git commit -m "Updated ${UPDATE}"
    cd ${WORKSPACE}/web
    drush updb --yes
    drush cr

  done < /tmp/updates.txt

  git push origin hotfix/auto-${DATE}
  echo "
##
# [Result] Updates installed and pushed to hotfix/auto-${DATE} branch
##
"

else
  echo "
##
# [Result] No security updates required
##
"
fi
