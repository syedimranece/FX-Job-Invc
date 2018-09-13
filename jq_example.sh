#!/bin/bash
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


runId=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X POST -d '{}' -u "shoukath@fxlabs.io":"shoukath@fxlabs.io"  https://cloud.fxlabs.io/api/v1/runs/job/8a8081e565b474b10165b4c24d1b1adf | jq -r '.["data"]|.id')

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

		if ("$status" -eq "COMPLETED") 
                  then
                	echo "Job run successfully completed"
                        exit 0
                fi
	done

if ("$status" -eq "TIMEOUT") 
then
 exit 1
else
 exit 0
fi

return 0













