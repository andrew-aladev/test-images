#!/usr/bin/env bash
set -e

rm -rf /var/cache/distfiles/{*,.*} || :
rm -rf /var/tmp/portage/{*,.*} || :
rm -rf /tmp/portage/{*,.*} || :
truncate --size 0 /var/log/emerge.log || :
