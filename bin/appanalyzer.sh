#!/bin/bash

#Sourcing environment variables

ANALYZER_HOME=/home/mapr/myProjects/YarnApplicationAnalyzer

source $ANALYZER_HOME/etc/analyzerEnv.sh

logFile="yarn-mapr-resourcemanager-sat-node5.log"

#Usage Function

usage()
{
        echo "USAGE: appAnalyzer.sh <application ID> <Logfile>"
}


#Application ID Validator

validate_id()
{

 	appId=$1
	printf "\n\n"
        echo "-------------------------------------------------------------------------------------------------"
	echo "Running check for Application: $1 in logs at $2"
	echo "-------------------------------------------------------------------------------------------------"

}

#Aalyzer Core functions

getContainers()
{
	appid=$1
	containers=(`echo "$appid" | awk -F '_' '{print $2 "_" $3 "_0"}'`)
	counter=0
	printf "\n\n"
	echo "-------------------------------------------------------------------------------------------------"	
	echo "Here is the list of Containers launched for application: $appid"
	echo "-------------------------------------------------------------------------------------------------"

	printf "\n"
	echo "-------------------------------------------------------------------------------------------------"
	echo "| Time Stamp           |   State  |          Applicatoin ID       | User | Queue name| Curr Apps|"
	echo "-------------------------------------------------------------------------------------------------"
	grep "in queue" $logFile | grep $appid | awk -F ' ' '{ print $1 $2 " | " $5 " | " $7 "|"$10 " | " $13 "  | " $NF }'
	echo "-------------------------------------------------------------------------------------------------"

	printf "\n"
	echo "Master Container On: "
	echo "==================== "
	printf "\n"
	grep $appid $logFile | grep "MasterContainer:"


	printf "\n\n"

        echo "Containers: "
        echo "=========== "	
	printf "\n"
	echo "-------------------------------------------------------------------------------------------------------------------------------------"
	grep $appid  $logFile | grep CONTAINERID | awk -F ' ' ' { print $1 " |" $2 "\t |" $7 "\t |" $10 "\t |" $12 "   |" }'
	echo "-------------------------------------------------------------------------------------------------------------------------------------"

	printf "\n\n"
	echo "Allocated Containers and  Nodes: "
        echo "=============================== "
        printf "\n"


	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"
	grep "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $18}'

	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

	containerIds=(`grep "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $7 "\n"}'`)
	totalContainers=`grep "SchedulerNode: Assigned container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $18}' | wc -l`
	
	printf "\n"
	printf "Total Number of Containers Allocated: $totalContainers"
	printf "\n\n"
        echo "Released Containers and  Nodes: "
        echo "=============================== "
        printf "\n"



        echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

        grep "SchedulerNode: Released container" $logFile | grep $containers | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $19}'

        echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"


	printf "\n\n"
        echo "Application State changes: "
        echo "========================= "
        printf "\n"



        echo "-----------------------------------------------------------------------------------------"
	grep $appid  $logFile | grep "State change" | awk -F ' ' '{print $1 "|" $2 " | " $5 " | " $9 "-->" $11}'
	echo "-----------------------------------------------------------------------------------------"

	printf "\n\n"
        echo "Container  State changes: "
        echo "========================= "
        printf "\n"	


	for cid in `grep "SchedulerNode: Assigned container" $logFile | grep "$containers" | awk -F ' ' '{ print $7 }'`
	do
		echo "-----------------------------------------------------------------------------------------"
		echo "$cid"; 
		echo "-----------------------------------------------------------------------------------------"
        	grep $cid $logFile  | grep "Container Transitioned" | grep "$containers" |  awk -F ' ' '{ print $1 "|" $2 " | " $5 " | " $9 " -->" $11 }'
		printf "\n"
	done;
	
}

#Execution starts here

if [ $# -lt 2 ]
then
	
	usage
else

	validate_id $1 $2
	getContainers $1 $2	
fi

