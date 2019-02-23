#!/bin/bash
# This script helps getting the Image Manager token (needed for IM API calls) from an Akamai property. 
# Just indicate the property name as a parameter 
# You can edit the EDGERCPAPISECTION variable if you are using a .edgerc section different than papi

# Edit the variables below if neeeded
EDGERC=$HOME/.edgerc
EDGERCPAPISECTION=papi

# No more changes needed below this point
# Check if parameter passed
if [ -z "$1" ] ; then
        echo "Please indicate the property manager configuration name. For example: $0 jgarza-test"
        exit 1
fi

# check if edgerc section exists 
grep $EDGERCPAPISECTION $EDGERC > /dev/null 2> /dev/null
if [ $? != 0 ] ; then 
	echo -e "ERROR: There is no section $EDGERCPAPISECTION on file $EDGERC"
	exit 1
fi

PAPISEARCH=`akamai property --section $EDGERCPAPISECTION search $1 2> /dev/null`

# Exit if the previous call failed
if [ $? != 0 ] ; then 
	echo -e "ERROR: \"akamai property --section $EDGERCPAPISECTION search $1\" failed. Please check your API credentials have access to the property manager API using \"akamai auth verify --section $EDGERCPAPISECTION\""
	exit 1
fi

echo $PAPISEARCH | grep accountId > /dev/null 2> /dev/null
if [ $? != 0 ] ; then 
	echo -e "ERROR: Configuration file $1 does not exist on this account"
	exit 1
fi

ASSETID=`echo $PAPISEARCH | jq '.versions.items[0].assetId'|sed 's/.*_//;s/"//'`

if [ $ASSETID = "null" ] ; then
        echo "ERROR: Configuration does not exist"
        exit 1
fi

POLICYNAME=`akamai property --section $EDGERCPAPISECTION retrieve $1 2> /dev/null|grep policyTokenDefault|sed 's/.*: //;s/,//;s/"//g'`

if [ -z ${POLICYNAME} ] ; then
        echo "ERROR: property $1 does not have an Image Manager behavior"
        exit 1
fi
echo "${POLICYNAME}-${ASSETID}"
