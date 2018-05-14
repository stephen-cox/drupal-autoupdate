#!/bin/bash

#
# Run Behat tests
#

ALIAS=$1
URL=$2

if [ ! -f ${WORKSPACE}/tests/behat.yml ]; then
  echo "default:
  suites:
    default:
      contexts:
        - FeatureContext
        - Drupal\DrupalExtension\Context\DrupalContext
        - Drupal\DrupalExtension\Context\MinkContext
        - Drupal\DrupalExtension\Context\MessageContext
        - Drupal\DrupalExtension\Context\DrushContext
  extensions:
    Behat\MinkExtension:
      goutte: ~
      selenium2: ~
      base_url: ${URL}
    Drupal\DrupalExtension:
      blackbox: ~
" > ${WORKSPACE}/tests/behat.yml
fi

echo "
##
# [Task] Running behat tests
##
"
cd ${WORKSPACE}/tests
../bin/behat || { exit 1; }
