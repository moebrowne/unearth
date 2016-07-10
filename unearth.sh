#!/bin/bash

domainName=$1
targetIP=$2

declare -A NAMESERVERS

NAMESERVERS['Google']="8.8.8.8 8.8.4.4"
NAMESERVERS['OpenDNS']="208.67.222.222 208.67.220.220 208.67.222.220 208.67.220.222"
NAMESERVERS['OpenDNSFamilyShield']="208.67.222.123 208.67.220.123"
NAMESERVERS['DNSAdvantage']="156.154.70.1 156.154.71.1"
NAMESERVERS['Verisign']="64.6.64.6 64.6.65.6"
NAMESERVERS['DNSWatch']="84.200.69.80 84.200.70.40"
NAMESERVERS['DYN']="216.146.35.35 216.146.36.36"
NAMESERVERS['Norton']="199.85.126.10 199.85.127.10"

table=""

for NSGroupName in "${!NAMESERVERS[@]}"; do

	NSGroupIPs=(${NAMESERVERS[$NSGroupName]})

	table+="$NSGroupName	"

	for NSGroupIP in "${NSGroupIPs[@]}"; do
		DIGOUTPUT=$(dig +nocmd +noall +answer "$domainName" A @$NSGroupIP)

		regexDNSRecord="^([[:alnum:]\-\.]+)[[:space:]]+([0-9]+)[[:space:]]+(IN)[[:space:]]+([[:alnum:]]+)[[:space:]]+(.+)$"
		[[ $DIGOUTPUT =~ $regexDNSRecord ]]

		reportedIP="${BASH_REMATCH[5]}"

		if [ "$reportedIP" == "$targetIP" ]; then
			table+="\e[32m#"
		else
			table+="\e[31m[$reportedIP] "
		fi

		table+="\e[0m"
	done

	table+="\n"

done

echo -ne "$table" | column -t -s $'\t'
