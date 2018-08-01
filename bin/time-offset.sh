#!/bin/bash

# 0. Input validation:

if [ "$(uname)" != "Linux" ]; then
    echo "$0 is for Linux"
    exit 1
fi

# 1. Check for ntpq:

if [[ ! -x /usr/bin/ntpq ]]
then
  echo "ntpq is NOT installed: please install it"
  exit 3
fi

# 2. Iterate on entities:

jsonEntities=""
entityCount=0


# 3. Data sampling:

# Get NTP offset
    
ntp_offset=$(/usr/bin/ntpq -pn | /usr/bin/awk 'BEGIN { offset=1000 } $1 ~ /\*/ { offset=$9 } END { print offset }')

#echo $ntp_offset
 
# 4. Serialize to JSON:

# Entity template evaluation
jsonEntity=`cat ./template/entity-time-offset.json`


# Replace the values in the JSON
# The @ in the sed command is a delimiter
    jsonEntity=`echo ${jsonEntity} | sed -e "s@NTPOFFSET@${ntp_offset}@"`
    
    separator=""
    entityCount=${entityCount}+1
    if (( ${entityCount} > 1 )); then
        separator=","
    fi

    jsonEntities="${jsonEntities}${separator}${jsonEntity}"

# 5. Integration template evaluation:

jsonIntegration=`cat ./template/integration-time-offset.json`

jsonIntegration=`echo ${jsonIntegration} | sed -e "s@ENTITIES@${jsonEntities}@"`

# Remove whitespaces
jsonIntegration=`printf "${jsonIntegration}" | tr -d [:space:]`


# 6. Output result:

echo "${jsonIntegration}"