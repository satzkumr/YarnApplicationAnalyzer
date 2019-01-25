# Yarn Application Analyzer tool for analyzing yarn-applications

Repo Details
============

Created By : Sathishkumar (satz)
Description: Shell-code that parses Yarn resource manager logs and grabs application details
Contact    : mrsathishkumar12@gmail.com

About Application
=================

	Yarn application analyzer will parse through the Resourcemanager logs and get the insights about the application.

Using the Tool
===============

	./appAnalyzer.sh <application ID> <Resourcemanager log file>

Current Features
================

	Curently this tool fetches below details from YARN-Resoucemanger logs

	1. Application and Queue datails
	2. Containes launched by the application
	3. Containers & its nodes, Allocations , Number of containers running on that Node manager (After allocation and De-allocations)
	4. Container status chages and its time stamps

	
