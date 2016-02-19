#!/bin/bash

domainName=$1

DIGOUTPUT=$(dig +nocmd +noall +answer "$domainName" A)

# Loop through each of the records returned from dig
while read -r record; do
    echo "$record"
done <<< "$DIGOUTPUT"
