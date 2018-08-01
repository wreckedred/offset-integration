#!/bin/sh

INTEGRATION_NAME=time-offset
CUSTOM_INTEGRATIONS=/var/db/newrelic-infra/custom-integrations
ETC_CONFIG=/etc/newrelic-infra/integrations.d

# Create these directories if they don't exist
mkdir ${CUSTOM_INTEGRATIONS}/bin 2>/dev/null
mkdir ${CUSTOM_INTEGRATIONS}/template 2>/dev/null

# Copy the config file to the integrations.d directory
cp ./config/*.yml ${ETC_CONFIG}
echo "All config files copied."

# Copy the configuration file to the custom-integrations directory
cp ./definition/${INTEGRATION_NAME}-def.yaml ${CUSTOM_INTEGRATIONS}
echo "Definition YAML file copied."

# Copy the template file to a template directory
cp ./template/*.json ${CUSTOM_INTEGRATIONS}/template/
echo "Template JSON files copied."

# Copy the shell script the bin directory
cp ./bin/${INTEGRATION_NAME}.sh ${CUSTOM_INTEGRATIONS}/bin/
echo "Bash script copied."

# Make sure the executable can be executed
chmod 755 ${CUSTOM_INTEGRATIONS}/bin/${INTEGRATION_NAME}.sh
echo "Bash script made into an executable."

# Restart the newrelic-infra agent
systemctl stop newrelic-infra
systemctl start newrelic-infra 
echo "Infrastructure service restarted"