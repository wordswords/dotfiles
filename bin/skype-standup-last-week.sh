#!/bin/bash

SKYPE_ID="live:david.craddock.arm" # change this to your skype ID as it appears in orgchart

echo "
select time(timestamp, 'unixepoch') as time, date(timestamp, 'unixepoch') as date, '

' as newline, body_xml, '


' as newline from messages
where
author = '$SKYPE_ID' and body_xml LIKE '%Today:%' and date BETWEEN datetime('now', '-6 days') AND datetime('now', 'localtime')
OR
author = '$SKYPE_ID' and body_xml LIKE '%SLS%' and date BETWEEN datetime('now', '-6 days') AND datetime('now', 'localtime')
OR
author = '$SKYPE_ID' and body_xml LIKE '%Yesterday%' and date BETWEEN datetime('now', '-6 days') AND datetime('now', 'localtime')
order by timestamp;" | sqlite3 ~/Library/Application\ Support/Skype/live\#3adavid.craddock.arm/main.db # change this to your sqlite database as it appears in the Skype directory
