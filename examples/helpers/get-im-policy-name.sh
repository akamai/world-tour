# This script helps getting the Image Manager token (needed for IM API calls) from an Akamai property. 
# Just indicate the property name as a parameter 
# You can edit the EDGERCPAPISECTION variable if you are using a .edgerc section different than papi

# Edit the variable below if neeeded
EDGERCPAPISECTION=papi

# No more changes needed below this point
# Check if parameter passed
if [ -z "$1" ] ; then
        echo "Please indicate the property manager configuration name. For example: $0 jgarza-test"
        exit 1
fi

POLICYNAME=`akamai property --section $EDGERCPAPISECTION retrieve $1 2> /dev/null|grep policyTokenDefault|sed 's/.*: //;s/,//;s/"//g'`
ASSETID=`akamai property --section $EDGERCPAPISECTION search $1 2> /dev/null | jq '.versions.items[0].assetId'|sed 's/.*_//;s/"//'`

#echo POLICYNAME=${POLICYNAME}
if [ -z ${POLICYNAME} ] ; then
        echo "ERROR: property $1 does not have an Image Manager behavior"
        exit 1
fi
#echo ASSETID=${ASSETID}

echo "${POLICYNAME}-${ASSETID}"
