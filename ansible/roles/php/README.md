# Ansible Role: PHP

Installs and configures PHP along with Composer and Drush

## Role Variables

Also see [defaults/main.yml](defaults/main.yml)

### PHP memory limit

```
php_memory_limit: 256M
```

### PHP max POST size

```
php_post_max_size: 50M
```

### PHP max file upload size

```
php_upload_max_filesize: 50M
```

### Install Composer

```
php_install_composer: true
```

### Install Drush

```
php_install_drush: false
```

### Drush version

```
drush_version: 8.1.10
```
