#!/bin/bash

#
# Synchronise Drupal site
#

ALIAS=$1
URL=$2

##
# Install Drupal module
function install() {
  MODULE=$1
  VERSION=$2

  echo "
  ##
  # [Task] Installing ${MODULE} module
  ##
  "
  cd ${WORKSPACE}
  git checkout -b hotfix/${MODULE}
  composer require drupal/${MODULE}:${VERSION} || exit 1
  git add -A :/
  git commit -m "Added ${MODULE} module"
  git checkout develop
  git merge hotfix/${MODULE}
  git checkout master
  git merge hotfix/${MODULE}
  git branch -d hotfix/${MODULE}
  git push origin master
  git push origin develop
}

# Sync database with live
echo "
##
# [Task] Syncing database
##
"
cd ${WORKSPACE}/web
drush sql-drop --yes
drush sql-sync @${ALIAS}.live @self --yes
drush cr

# Install and enable stage_file_proxy module
if [ ! -d ${WORKSPACE}/web/modules/contrib/stage_file_proxy ]; then
  install "stage_file_proxy" "^1.0-alpha1"
fi
echo "
##
# [Task] Enabling stage_file_proxy module
##
"
cd ${WORKSPACE}/web
drush pm-enable stage_file_proxy --yes || exit 1
echo "
# Stage file proxy
\$config['stage_file_proxy.settings']['origin'] = '${URL}';
\$config['stage_file_proxy.settings']['hotlink'] = 1;" >> sites/default/settings.local.php

# Install and enable devel
if [ ! -d ${WORKSPACE}/web/modules/contrib/devel ]; then
  install "devel" "~1"
fi
echo "
##
# [Task] Enabling devel module
##
"
cd ${WORKSPACE}/web
drush pm-enable devel --yes || exit 1
drush cr
echo "
# Disable email delivery
\$config['system.mail']['interface']['default'] = 'devel_mail_log';" >> sites/default/settings.local.php
