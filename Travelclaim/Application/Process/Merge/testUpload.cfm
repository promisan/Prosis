<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- Initial a notification eMail for returning travellers Commented Returnmail.cfm in this development version
Should uncomment it if moved to production JG 31-07-2009
--->
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cf_wait1 icon="circle" text="Extracting data" flush="force">

<!--- processing locations --->
 
<cfquery name="Get" 
datasource="AppsTravelClaim"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter 
</cfquery>

<cfset Mission     = "#Get.SourceDutyStation#">

<cfset DSNDW       = "#Get.AliasSourceData#">
<cfset SRVDW       = "#Get.SourceServer#">
<cfset DBDW        = "#Get.SourceDatabase#">
<cfset SCHdw       = "#Get.SourceSchema#">

<cfquery name="sys" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter 
</cfquery>

<!--- <cfset SERPortal   = "[DPKO-PMSS-04]"> --->
<cfset ledger      = "[#sys.databaseserver#].Accounting.dbo">
<cfset employ      = "[#sys.databaseserver#].Employee.dbo">

<!--- 
section -1. initially populate travel claim database (before a DTS)
--->
<!--- init temp tables --->

<cf_waitEnd>
<cf_wait1 icon="circle" text="Initializing" flush="force">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Initializing">
<!---
<cfinclude template="DWExtract/InitUpload.cfm"> 
--->
<cf_waitEnd>
<cf_wait1 icon="circle" text="Scope" flush="force">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Scope">

<cf_waitEnd>	
<!---
<cfinclude template="DWExtract/Scope.cfm"> 
--->
Scope<br>

<cf_waitEnd>
<cf_wait1 icon="circle" text="Extracting" flush="force">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Extraction of Table DW ">
	<!---
<cfinclude template="DWExtract/Extract.cfm"> 
--->
Extracting<br>

<cf_waitEnd>
<!---
<cf_wait1 icon="circle" text="Moving Tables" flush="force">
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Moving tables to Operational database">
--->
<cfinclude template="DWExtract/JGMoveTable.cfm"> 
<!---
Moving tables<br>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Migrating Data">

<cf_waitEnd>	
--->
<!---
<cf_wait1 icon="circle" text="Migrating data" flush="force">
	<!--- 
	section 0. initially populate travel claim database (before a DTS)
	--->
	<!--- init temp tables --->
	
	<cfinclude template="InitialLoad/InitUpload.cfm"> 
	
	<!--- generate various reference tables --->
	<cfinclude template="InitialLoad/ReferenceTables.cfm">
	Reference tables
	<cfinclude template="InitialLoad/AddCities.cfm">
	<br>Cities
	<!--- generate claim request --->
	<cfinclude template="InitialLoad/TravelRequest.cfm">
	<br>Travel request
	<!--- prepare funding reference file --->
	<cfinclude template="InitialLoad/PrepareRequestUnit.cfm">
	
	<!--- prepare processing reference file --->
	<cfinclude template="InitialLoad/PrepareBankAccount.cfm">
	<!--- disabled 	<cfinclude template="PrepareAddress.cfm">
	--->	
	<!--- prepare funding reference file --->
	<cfinclude template="InitialLoad/FundingSupport.cfm">
	<cfinclude template="InitialLoad/Finish.cfm">

<!--- 
section 1. Reset claims that were not uploaded to be discussed
   -  Set status = 2 and exportFileNo = NULL
   -  Undo entry in ExportFileNo
--->   
<!--- pending --->
	
<!---	
section 2. update claim status as result of upload into IMIS
   -  update status
   -  make a workflow entry 
   -  trigger eMail + attachment
--->   
   
<cf_waitEnd>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "IMIS Processing Information">
	
<cf_wait1 icon="circle" text="Reflect IMIS processing" flush="force">   

<!---	 
section 2. record IMIS recorded claims without linkage under OTHER
--->   

<!--- Process IMIS claim interface results --->
<cfinclude template="../ValidationRules/ValidationInterface.cfm">

<cf_waitEnd>
<cf_wait1 icon="circle" text="Merging" flush="force">   
<!--- Process IMIS upload results --->
<cfinclude template="MergeClaim.cfm"> 

<cf_waitEnd>
<cf_wait1 icon="circle" text="Welcome back Mail" flush="force">   

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Welcome back Notification">
<!--- Initial a notification eMail for returning travellers --->
<!--- JG commenting it in 901 Please do not move the code in production
since this will stop emails to be sent
 

<cfinclude template="ReturnMail.cfm"> 
--->
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Uploading Outside Portal Claim">
		
<cf_waitEnd>	
<cf_wait1 icon="circle" text="Uploading Outside Portal Claim" flush="force">   	
<cfinclude template="UploadOther.cfm">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Merging TVCV Lines">

<cf_waitEnd>
<cf_wait1 icon="circle" text="Uploading Claim Lines IMIS" flush="force">  
<cfinclude template="UploadLines.cfm">

<cf_waitEnd>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed">

<cfparam name="URL.string" default="">

<cfif url.string neq "">
	<cfoutput>
		<script language="JavaScript">
		window.location = "../Export/ExportList.cfm?#URL.String#"
		</script>
	</cfoutput>
</cfif>

--->