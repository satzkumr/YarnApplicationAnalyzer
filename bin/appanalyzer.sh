#!/bin/bash

#Sourcing environment variables

ANALYZER_HOME=/home/sathish/sathish-pub-git/YarnApplicationAnalyzer

source $ANALYZER_HOME/etc/analyzerEnv.sh

appid=$1
logFile=$2
echo $2
containers=(`echo "$appid" | awk -F '_' '{print $2 "_" $3 "_0"}'`)


#Usage Function
usage()
{
        echo "USAGE: appAnalyzer.sh <application ID> <Logfile>"
}


#Application ID Validator

validate_id()
{

	#App ID and path validations goes here!
        echo "-------------------------------------------------------------------------------------------------"
	echo "Gathering information for Application: $1 from the logs $2"
	echo "-------------------------------------------------------------------------------------------------"

}

#Aalyzer Core functions

getContainers()
{

	counter=0
	printf "\n"
	echo "Master Container On: "
	echo "==================== "
	printf "\n"
	grep --no-filename $appid $logFile | grep "MasterContainer:"
	printf "\n\n"
        echo "Containers: "
        echo "=========== "	
	printf "\n"
	echo "-------------------------------------------------------------------------------------------------------------------------------------"
	grep --no-filename $appid  $logFile | grep CONTAINERID | awk -F ' ' ' { print $1 " |" $2 "\t |" $7 "\t |" $10 "\t |" $12 "   |" }'
	echo "-------------------------------------------------------------------------------------------------------------------------------------"

	printf "\n\n"
	echo "Allocated Containers and  Nodes: "
        echo "=============================== "
        printf "\n"
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"
	grep --no-filename "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $14 " | " $17}'
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

	containerIds=(`grep --no-filename "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $7 "\n"}'`)
	totalContainers=`grep --no-filename "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $18}' | wc -l`
	
	printf "\n"
	printf "Total Number of Containers Allocated: $totalContainers"
	printf "\n\n"
        echo "Released Containers and  Nodes: "
        echo "=============================== "
        printf "\n"



        echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"
        grep --no-filename "SchedulerNode: Released container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $14 " | " $18}'
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"


}


#Gets the application state changes
#Uses application id

getAppStateChanges()
{

	printf "\n\n"
        echo "Application State changes: "
        echo "========================= "
        
	printf "\n"
        echo "-----------------------------------------------------------------------------------------"
	grep --no-filename $appid  $logFile | grep "State change" | awk -F ' ' '{print $1 "|" $2 " | " $5 " | " $9 "-->" $11}'
	echo "-----------------------------------------------------------------------------------------"

}


#Gets the Individual containers state changes
#Argument as application ID

getContainerStateChanges()
{
	printf "\n\n"
        echo "Container  State changes: "
        echo "========================= "
        printf "\n"	
	grep -q --no-filename "SchedulerNode: Assigned container" $logFile | grep "$containers" | awk -F ' ' '{ print $7 }'

	for cid in `grep --no-filename "SchedulerNode: Assigned container" $logFile | grep "$containers" | awk -F ' ' '{ print $7 }'`
	do
		echo "-----------------------------------------------------------------------------------------"
		echo "$cid"; 
		echo "-----------------------------------------------------------------------------------------"
        	grep --no-filename $cid $logFile  | grep "Container Transitioned" | grep "$containers" |  awk -F ' ' '{ print $1 "|" $2 " | " $5 " | " $9 " -->" $11 }'
		printf "\n"
	done;
	
}


#Getting Queue Details
#Arguments: Application ID as $1

getQueueDetails()
{
        containers=(`echo "$appid" | awk -F '_' '{print $2 "_" $3 "_0"}'`)
        counter=0
        printf "\n"
        echo "-------------------------------------------------------------------------------------------------"
        echo "| Time Stamp           |   State  |          Applicatoin ID       | User | Queue name| Curr Apps|"
        echo "-------------------------------------------------------------------------------------------------"
        grep --no-filename "in queue" $logFile | grep $appid | awk -F ' ' '{ print $1 $2 " | " $5 " | " $7 "|"$10 " | " $13 "  | " $NF }'
	echo "-------------------------------------------------------------------------------------------------"

}

#Execution starts here

if [ $# -lt 2 ]
then
	
	usage
else

	validate_id $1 $2
	getQueueDetails
	getAppStateChanges
	getContainers
	getContainerStateChanges

fi

