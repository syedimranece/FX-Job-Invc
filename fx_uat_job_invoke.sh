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


runId=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X POST -d '{}' -u "${FX_USER}":"${FX_PWD}"  https://cloud.fxlabs.io/api/v1/runs/job/${FX_JOBID}?region=${REGION} | jq -r '.["data"]|.id')

echo "runId =" $runId
if [ -z "$runId" ]
then
	  echo "RunId = " "$runId"
          echo "Invalid runid"
          exit 1
fi


taskStatus="WAITING"
echo "taskStatus = " $taskStatus



while [ "$taskStatus" == "WAITING" -o "$taskStatus" == "PROCESSING" ]
	 do
		sleep 5
		 echo "Checking Status...."
		  taskStatus=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X GET -u "${FX_USER}":"${FX_PWD}"  https://cloud.fxlabs.io/api/v1/runs/${runId} | jq -r '.["data"]|.task.status')
		
		#echo "temp response = " $runResponse
		#runResponse_=$runResponse
		
		#jq -n --argjson data "$runResponse" '$data.data.task.status'
               
				
		echo "taskStatus = " $taskStatus

		if [ "$taskStatus" == "COMPLETED" ];then
                  	 passPercent=$(curl -k --header "Content-Type: application/json;charset=UTF-8" -X GET -u "${FX_USER}":"${FX_PWD}"  https://cloud.fxlabs.io/api/v1/runs/${runId} | jq -r '.["data"]|.task.totalTests') 
			echo "TotalTest =" "$passPercent"
                        
                	echo "Job run successfully completed"
                        exit 0

                fi
	done

if [ "$taskStatus" == "TIMEOUT" ];then 
 exit 1
else
 exit 0
fi

return 0













