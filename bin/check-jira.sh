#!/bin/bash -e
curl -o ./jira-json-dump.json -s -u $USER -X GET -H "Content-Type: application/json" https://jira.arm.com/rest/api/2/search\?jql\=assignee\=$USER\&maxResults\=9999
jq -r '.issues[] | (.key),(.fields | (.status.name),(.summary))' ./jira-json-dump.json | paste  - - - | grep -v 'Closed'

