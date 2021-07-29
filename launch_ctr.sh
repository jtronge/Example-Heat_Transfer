#!/bin/sh

rm -rf jtronge%heat-transfer jtronge%heat-transfer.tar.gz
doas ~/charliecloud-0.22/bin/ch-builder2tar jtronge/heat-transfer .
~/charliecloud-0.22/bin/ch-tar2dir jtronge%heat-transfer.tar.gz .
~/charliecloud-0.22/bin/ch-run -w -u 0 ./jtronge%heat-transfer /bin/zsh
