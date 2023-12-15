#!/bin/bash

# findsuid--Checks all SUID files or programs to see if they're writeable,
#   and outputs the matches in a friendly and useful format

mtime="7"            # How far back (in days) to check for modified cmds.
verbose=0            # By default, let's be quiet about things.

if [ "$1" = "-v" ] ; then
 verbose=1          # User specified findsuid -v, so let's be verbose.
fi

# find -perm looks at the permissions of the file: 4000 and above
#   are setuid/setgid.

find / -type f -perm /4000 -print0 | while read -d '' -r match 2>/dev/null
do
 if [ -x "$match" ] ; then

   # Let's split file owner and permissions from the ls -ld output.

   owner="$(ls -ld $match | awk '{print $3}')"
   perms="$(ls -ld $match | cut -c5-10 | grep 'w')"

   if [ ! -z $perms ] ; then
     echo "**** $match (writeable and setuid $owner)"
   elif [ ! -z $(find $match -mtime -$mtime -print) ] ; then
     echo "**** $match (modified within $mtime days and setuid $owner)"
   elif [ $verbose -eq 1 ] ; then
     # By default, only dangerous scripts are listed. If verbose, show all.
     lastmod="$(ls -ld $match | awk '{print $6, $7, $8}')"
     echo "     $match (setuid $owner, last modified $lastmod)"
   fi
 fi
done

exit 0
