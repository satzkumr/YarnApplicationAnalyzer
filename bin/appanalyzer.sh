#!/bin/bash

#Sourcing environment variables

ANALYZER_HOME=/home/mapr/myProjects/YarnApplicationAnalyzer

source $ANALYZER_HOME/etc/analyzerEnv.sh


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
	counter=0
	printf "\n\n"
	echo "-------------------------------------------------------------------------------------------------"	
	echo "Here is the list of Containers launched for application: $appid"
	echo "-------------------------------------------------------------------------------------------------"

	printf "\n\n"

	echo "Master Container On: "
	echo "==================== "
	printf "\n"
	grep $appid yarn-mapr-resourcemanager-sat-node5.log | grep "MasterContainer:"


	printf "\n\n"

        echo "Containers: "
        echo "=========== "	
	printf "\n\n"

	#echo "-------------------------------------------------------------------------------------------------"
        #echo "|   Time stamp             |  Operation        |   Status   |                                     | Node                                   |"
	#echo "-------------------------------------------------------------------------------------------------"

	grep application_1489052008885_0015 yarn-mapr-resourcemanager-sat-node5.log | grep CONTAINERID | awk -F ' ' ' { print $1 " |" $2 "\t |" $7 "\t |" $10 "\t |" $12 "   |" }'


	printf "\n\n"
	echo "Allocated Containers and  Nodes: "
        echo "=============================== "
        printf "\n"



	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

	grep "SchedulerNode: Assigned container" yarn-mapr-resourcemanager-sat-node5.log | grep 1489052008885_0015_01 | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $18}'

	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

	printf "\n"
	
	totalContainers=`grep "SchedulerNode: Assigned container" yarn-mapr-resourcemanager-sat-node5.log | grep 1489052008885_0015_01 | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $18}' | wc -l`
	
	printf "Total Number of Containers Allocated: $totalContainers"

	printf "\n\n"
        echo "Released Containers and  Nodes: "
        echo "=============================== "
        printf "\n"



        echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

        grep "SchedulerNode: Released container" yarn-mapr-resourcemanager-sat-node5.log | grep 1489052008885_0015_01 | awk -F ' ' '{ print $1 $2 " | " $5 " | "  $7 " | " $10 $11 $12 $13 " | " $15 " | " $19}'

        echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

}

#Execution starts here

if [ $# -lt 2 ]
then
	
	usage
else

	validate_id $1 $2
	getContainers $1 $2	
fi

