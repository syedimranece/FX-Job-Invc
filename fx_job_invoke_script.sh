#!/bin/sh
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


runId=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X POST -d '{}' -u "${FX_USER}":"${FX_PWD}"  https://cloud.fxlabs.io/api/v1/runs/job/${FX_JOBID}?region=${REGION} | jq -r '.["data"]|.id')

if [ -z "$runId" ]
then
	 echo "RunId = " "$runId"
        echo "Invalid runid"
fi


status=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X GET -u "shoukath@fxlabs.io":"shoukath@fxlabs.io"  https://cloud.fxlabs.io/api/v1/runs/${runId} | jq -r '.["data"]|.task.status')


echo "status = " $status


while [ "$status" = "WAITING"  -o  "$status" = "PROCESSING" ]
	 do
		sleep 10
	status=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X GET -u "shoukath@fxlabs.io":"shoukath@fxlabs.io"  https://cloud.fxlabs.io/api/v1/runs/${runId} | jq -r '.["data"]|.task.status')
		
		echo "status = " $status

		if [ $status = "COMPLETED" ];then
                  
                	echo "Job run successfully completed"
                        exit 0

                fi
	done

if [ $status = "TIMEOUT" ] 
then
 exit 1
else
 exit 0
fi
