#!/bin/sh

#############################################################################
#                                                                           #
# createProject.sh : Creates Project if does not exists                     #
#                                                                           #
#############################################################################

PROJECT_URL=$1
exporter_user=$2
exporter_password=$3

    if [ -z "$PROJECT_URL" ]; then
      echo "Missing template parameter PROJECT_URL"
      exit 1
    fi
    
    if [ -z "$exporter_user" ]; then
      echo "Missing template parameter exporter_user"
      exit 1
    fi

    if [ -z "$exporter_password" ]; then
      echo "Missing template parameter exporter_password"
      exit 1
    fi



echo "Check Project exists"
        name=$(curl --location --request GET ${PROJECT_URL} \
                --header 'Accept: application/json' \
                -u $(exporter_user):$(exporter_password) | jq -r '.output.name')
        echo ${name}
        if [ "$name" == null ]; then
            echo "Project does not exists, creating ..."
            #### Create project in the tenant
            json='{ "name": "'$(repoName)'", "description": "Created by Automated CI for feature branch"}'
            projectName=$(curl --location --request POST ${PROJECT_URL} \
            --header 'Content-Type: application/json' \
            --header 'Accept: application/json' \
            --data-raw "$json" -u $(exporter_user):$(exporter_password)| jq '.')
        else
            echo "Projecxt already exixts with name:" ${name}
            exit 0
        fi