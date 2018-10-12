
# puppet_mountpoint

A defined type to make creating additional Puppet mountpoints easier.

read the docs here

* https://puppet.com/docs/puppet/latest/file_serving.html
* https://puppet.com/docs/puppet/latest/config_file_fileserver.html


#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet_mountpoint](#setup)
    * [What puppet_mountpoint affects](#what-puppet_mountpoint-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet_mountpoint](#beginning-with-puppet_mountpoint)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

this module hopefully takes the pain out of config and auth config for mountpoints for the Puppet master or compile masters.


## Setup

### What puppet_mountpoint affects

Changes Hocon settings for mountpoint auth https://puppet.com/docs/puppet/6.0/file_serving.html#controlling-access-to-a-custom-mount-point-in-authconf

Controls legacy settings in auth.conf https://puppet.com/docs/puppet/6.0/file_serving.html#legacy-authconf

Creates a new mountpoint in fileserver.conf https://puppet.com/docs/puppet/6.0/file_serving.html#creating-a-new-mount-point-in-fileserverconf

### Setup Requirements **OPTIONAL**

Will only work on a Puppet Master or Compile master with the fileserver service.

### Beginning with puppet_mountpoint

Decide on the name and folder path for your mount point.
create a profile with the resources to configure the `$mountpoint::path` folder

## Usage

Create a profile with the file resources needed to ensure the puppet_mountpoint::path is created then provide that Absolute path as a variable and the name of the mountpoint.

```
#in a profile applied to puppet master
puppet_mountpoint{ 'name_of_mountpoint':
  path => "/path/to/valid/folder",
}

#in a separate nodes manifest
file {'/example/file':
  ensure => file,
  source => 'puppet:///name_of_mountpoint/filename',
}
```
## Limitations

The module does not create the mountpoint::path folder, there are too many variables in depth and ownership just create file resources to compensate.
What it does do is allow you to create multiple mountpoints and authenticate them as desired.

## Development

Please feel free

## Release Notes/Contributors/Etc.
