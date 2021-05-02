#!/usr/bin/env bash
set -e

emerge --depclean
rm -rf /var/tmp/portage/{*,.*} || :
rm -rf /tmp/portage/{*,.*} || :
truncate --size 0 /var/log/emerge.log
eclean --destructive distfiles
