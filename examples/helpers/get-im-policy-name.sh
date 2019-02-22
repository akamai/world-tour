EDGERCPAPISECTION=papi
POLICYNAME=`akamai property --section $EDGERCPAPISECTION retrieve $1 2> /dev/null|grep policyTokenDefault|sed 's/.*: //;s/,//;s/"//g'`
ASSETID=`akamai property --section $EDGERCPAPISECTION search $1 2> /dev/null | jq '.versions.items[0].assetId'|sed 's/.*_//;s/"//'`

#echo POLICYNAME=${POLICYNAME}
if [ -z ${POLICYNAME} ] ; then
        echo "ERROR: property $1 does not have an Image Manager behavior"
        exit 1
fi
#echo ASSETID=${ASSETID}

echo "${POLICYNAME}-${ASSETID}"
