#!/bin/bash

domainName=$1

declare -A NAMESERVERS

NAMESERVERS[Google]="8.8.8.8 8.8.4.4"
NAMESERVERS[OpenDNS]="208.67.222.222 208.67.220.220 208.67.222.220 208.67.220.222"
NAMESERVERS[OpenDNSFamilyShield]="208.67.222.123 208.67.220.123"

echo "NS Group Name	NS IP	Domain	TTL	IN	Record Type	IP"

for NSGroupName in "${!NAMESERVERS[@]}"; do

	NSGroupIPs=(${NAMESERVERS[$NSGroupName]})

	for NSGroupIP in "${NSGroupIPs[@]}"; do
		DIGOUTPUT=$(echo -n "$NSGroupName	$NSGroupIP	" && dig +nocmd +noall +answer "$domainName" A @$NSGroupIP)
		echo "$DIGOUTPUT"
	done

done
exit;

# Loop through each of the records returned from dig
while read -r record; do
	echo "$record"
done <<< "$DIGOUTPUT"
