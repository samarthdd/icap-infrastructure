#!/usr/bin/env bash

set -e
set -o pipefail

checkPrereqs () {
    if ! which az > /dev/null; then
      printf "ERROR: az not found in path\n"
    fi
    if ! which yq > /dev/null; then
      printf "ERROR: yq not found in path\n"
    fi
    if ! which find > /dev/null; then
      printf "ERROR: find not found in path\n"
    fi
    if ! which docker > /dev/null; then
      printf "ERROR: docker not found in path\n"
    fi
}

registriesLogin () {
    printf "Logging into registries\n"
    accessToken=$(az acr login --name gwicapcontainerregistry --expose-token 2>/dev/null | jq -r '.accessToken')
    echo -n "$accessToken" | docker login gwicapcontainerregistry.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin > /dev/null
    dockerHubToken=$(az keyvault secret show --vault-name gw-icap-keyvault --name Docker-PAT | jq -r '.value')
    dockerHubUsername=$(az keyvault secret show --vault-name gw-icap-keyvault --name Docker-PAT-username | jq -r '.value')
    echo -n "$dockerHubToken" | docker login --username "$dockerHubUsername"	--password-stdin > /dev/null
    printf "Login succeeded\n"
}

migrateChartImages () {
    for img in $(yq read -p p values.yaml 'imagestore.*'); do
        registry=$(yq read values.yaml "$img.registry")
        repository=$(yq read values.yaml "$img.repository")
        tag=$(yq read values.yaml "$img.tag")
        printf "  %s\t->\t%s\n" "$registry$repository:$tag" "gwicapcontainerregistry.azurecr.io/$repository:$tag"
        docker pull -q "$registry$repository:$tag" > /dev/null
        docker tag "$registry$repository:$tag" "gwicapcontainerregistry.azurecr.io/$repository:$tag"
        docker push "gwicapcontainerregistry.azurecr.io/$repository:$tag" > /dev/null
        docker rmi "$registry$repository:$tag" > /dev/null
    done
}

checkPrereqs

registriesLogin

find . -maxdepth 1 -mindepth 1 -type d | while read -r d; do
    cd $d

    if [[ -f values.yaml ]]; then
        printf "\nNow processing %s\n" "$d"
        migrateChartImages
        printf "\n"
    else
        printf "Skipping %s; no values file\n" "$d"
    fi
    cd ..
done
