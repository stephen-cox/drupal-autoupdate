#!/bin/bash

#
# Setup Drupal if needed
#

ALIAS=$1

echo "
##
# [Task] Configuring Drupal
##
"
cd ${WORKSPACE}/web/sites/default/
mkdir files
chmod 777 files
chmod g+s files
mkdir files/private
echo "<?php

# Database
\$databases['default']['default'] = array(
  'driver' => 'mysql',
  'username' => 'drupal',
  'password' => 'drupal',
  'port' => '',
  'host' => 'localhost',
  'database' => '${ALIAS}',
);

# Private files
\$settings['file_private_path'] = '${WORKSPACE}/web/sites/default/files/private';" > settings.local.php
