#!/bin/bash

# load environment variables
set -a && source .env && set +a

# Required variables
required_vars=(
    "resource_group"
    "location"
    "iothub_name"
)

# Set the current directory to where the script lives.
cd "$(dirname "$0")"

# Function to check if all required arguments have been set
check_required_arguments() {
    # Array to store the names of the missing arguments
    local missing_arguments=()

    # Loop through the array of required argument names
    for arg_name in "${required_vars[@]}"; do
        # Check if the argument value is empty
        if [[ -z "${!arg_name}" ]]; then
            # Add the name of the missing argument to the array
            missing_arguments+=("${arg_name}")
        fi
    done

    # Check if any required argument is missing
    if [[ ${#missing_arguments[@]} -gt 0 ]]; then
        echo -e "\nError: Missing required arguments:"
        printf '  %s\n' "${missing_arguments[@]}"
        [ ! \( \( $# == 1 \) -a \( "$1" == "-c" \) \) ] && echo "  Either provide a .env file or all the arguments, but not both at the same time."
        [ ! \( $# == 22 \) ] && echo "  All arguments must be provided."
        echo ""
        exit 1
    fi
}

####################################################################################

# Check if all required arguments have been set
check_required_arguments

####################################################################################

#
# Create/Get a resource group.
#
rg_query=$(az group list --query "[?name=='$resource_group']")
if [ "$rg_query" == "[]" ]; then
   echo -e "\nCreating Resource group '$resource_group'"
   az group create --name ${resource_group} --location ${location}
else
   echo "Resource group $resource_group already exists."
fi


#
# Create IoT Hub.
#
hb_query=$(az iot hub list --query "[?name=='$iothub_name']")
if [ "$hb_query" == "[]" ]; then
   echo -e "\nCreating IoT Hub '$iothub_name'"
   az iot hub create --resource-group $resource_group --name ${iothub_name} --sku F1 --partition-count 2
else
   echo "IoT Hub $iothub_name already exists."
fi

#
# Register device
#
de_query=$(az iot hub device-identity list --hub-name ${iothub_name} --query "[?deviceId=='$edge_device_id']")
if [ "$de_query" == "[]" ]; then
   echo -e "\nCreating IoT Edge device '$edge_device_id'"
   az iot hub device-identity create --device-id $edge_device_id --edge-enabled --hub-name ${iothub_name}
else
   echo "IoT Edge device $edge_device_id already exists."
fi

# Show connection string
az iot hub device-identity connection-string show --device-id $edge_device_id --hub-name ${iothub_name} -o tsv
