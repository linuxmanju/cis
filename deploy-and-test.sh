#!/usr/bin/env bash

rsync -avdt --delete ../abinbev_cis_suid_rem master:/tmp/

ssh master "pushd /tmp;sudo  /opt/puppetlabs/bin/puppet apply  --modulepath=/tmp/ -e 'include abinbev_cis_suid_rem'"
