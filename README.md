# Drupal auto-updater example

Example setup for deploying Drupal 8 security updates.

## Requirements

  * Drupal 8.5+ codebase in a monolithic git repo; e.g. https://github.com/stephen-cox/umami
  * Drupal 8 and the following  packages and modules installed using Composer:
    - drupal/devel ^1.2
    - drupal/drupal-extension ~3.0
    - drupal/stage_file_proxy ^1.0-alpha1
    - drush/drush ~9
  * Drush 9 aliases in the repo; e.g. https://github.com/stephen-cox/umami/blob/master/drush/sites/umami.site.yml

An example composer.json file for installing all the dependencies can be seen here: https://github.com/stephen-cox/umami/blob/master/composer.json

## Server architecture

Three servers are created using vagrant: live, test and jenkins

### Live (http://umami.live.localhost)

This server is designed to simulate a production server

### Test (http://umami.test.localhost)

This server is designed to simulate a testing server. This is configured as a Jenkins slave, which allows the Jenkins server to run jobs on it.

### Jenkins (http://jenkins.localhost:8080)

This is the CI server running Jenkins. It is designed to run the update and test process on the test server and then deploy the updates to the live server.

## Update process

Running the Jenkins update job (http://jenkins.localhost:8080/job/umami) does the following:

  * Setup the site on the test server
  * Synchronise the test site with the live site
  * Run behat tests
  * Install any required security updates on a git hotfix branch
  * Run behat tests

The site can then be manually tested on the test server and if all is fine, the hotfix branch can be finalised and deployed to the live server.



## Installation

To do!

### /etc/hosts

Add the following to your /etc/hosts file:

```
# Drupal auto-update example hosts
192.168.30.11 test.localhost umami.test.localhost
192.168.30.12 live.localhost umami.live.localhost
192.168.30.13 jenkins.localhost
```
