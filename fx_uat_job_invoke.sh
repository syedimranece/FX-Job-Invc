#!/bin/bash -x
# Begin

FX_USER=$1
FX_PWD=$2
FX_JOBID=$3
REGION=$4
TAGS=$5
SUITES=$6
CATEGORIES=$7


echo "user=${FX_USER}" 
echo "region=${REGION}"
echo "jobid=${FX_JOBID}"

curl -k --header "Content-Type: application/json;charset=UTF-8" -X POST -d '{}' -u "${FX_USER}":"${FX_PWD}" http://localhost:8080/api/v1/runs/job/"${FX_JOBID}"?region="${REGION}"&tags="${TAGS}"&suites="${SUITES}"&categories="${CATEGORIES}"

Exit code 0
