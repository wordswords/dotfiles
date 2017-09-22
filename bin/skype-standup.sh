SKYPE_ID="live:david.craddock.arm"

echo "
select time(timestamp, 'unixepoch') as time, date(timestamp, 'unixepoch') as date, '

' as newline, body_xml from messages
where
author = '$SKYPE_ID' and body_xml LIKE '%Today:%'
OR
author = '$SKYPE_ID' and body_xml LIKE '%SLS%'
OR
author = '$SKYPE_ID' and body_xml LIKE '%Yesterday%'
order by timestamp;" | sqlite3 ~/Library/Application\ Support/Skype/live\#3adavid.craddock.arm/main.db
