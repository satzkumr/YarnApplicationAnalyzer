# Yarn Application Analyzer tool for analyzing yarn-applications

Repo Details
============

Created By : Sathishkumar (satz)
Description: Shell-code that parses Yarn resource manager logs and grabs application details
Contact    : mrsathishkumar12@gmail.com

About Application
=================

	Yarn application analyzer will parse through the application logs and present results

Using the Tool
===============

	./appAnalyzer.sh <application ID> <logFilename>

Current Features
================

	Curently this tool fetches below details from yarn-resoucemanger logs

	1. Application and Queue datails
	2. Containes launched by the application
	3. Containers & its nodes, Allocations , Number of containers running on that Node manager
	4. Container status chages and its time stamps

	
