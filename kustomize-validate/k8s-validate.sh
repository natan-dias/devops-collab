#!/bin/bash

set -uo pipefail

overlay=$1
ERR=0

# Check for kubernetes-validate module
command -v kubernetes-validate &> /dev/null || { echo "Install kubernetes-validate with 'pip install kubernetes-validate'"; exit 1; }

# Check for kustomize installation
command -v kustomize &> /dev/null || { echo "Install kustomize from 'https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/'"; exit 1; }

# Get API Version
# To get the API version from your k8s cluster, please uncomment the following lines and comment the line with the API VERSION hard coded
#api_server=URL-to-k8s-API
#API_VERSION=$(curl -k ${api_server}/version | jq -r '[.major,.minor]|join(".")')

API_VERSION=1.24 # Just an example using version 1.24

LOCAL="webserver-example" # Name of your service folder

k8s_validate() {
    kubernetes-validate -k $API_VERSION --strict $1.$2.yaml 2> /dev/null | grep -v ^INFO && ERR=1

    if [ $ERR == 1 ]; then
        echo "[ERROR] during validate kustomize build for $1.$2.yaml"
        exit $ERR
        else
            echo "kustomize validation for $1.$2.yaml is OK"
    fi
}

# Check target configuration

declare -a target_list=("dev" "prd")

declare -a suffix=("" "-suffix") # To add a suffix to your list, just add it like the first list.

readarray -t full_list < <(IFS=,; eval "printf '%s\n' {${target_list[*]}}{${suffix[*]}}")

for env in "${full_list[@]}"
do
    if [ -d "$LOCAL/$overlay/$env" ]; then
        echo "kustomize for $overlay/$env - checking"

        kustomize build $LOCAL/$overlay/$env > $overlay.$env.yaml

        if [ "$?" -ne "0" ]; then
            echo "[ERROR] Checking kustomize build for $overlay/$env"
            echo "Please execute kustomize build manually"
            exit 1
        fi

        k8s_validate $overlay $env

    else
        echo "[WARN] No Kustomize file for $LOCAL/$overlay/$env. Skipping..."
    fi
done

# FOR DEBUG ONLY (Can be removed)

echo $SECONDS # To get the duration of this script
echo "Exit code $ERR" # To confirm exit code with variable
echo "End of Script without errors."

exit $ERR

