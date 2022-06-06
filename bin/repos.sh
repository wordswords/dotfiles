#!/bin/bash -e

find "$(pwd)" -name '.git' -type 'd' -printf "[ %p ]" -exec /bin/bash -c "./show-branch.sh {}" \; 2>/dev/null | egrep --color=always -v  '\[\]'

