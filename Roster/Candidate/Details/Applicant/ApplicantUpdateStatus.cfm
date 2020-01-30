<cfset CLIENT.actionClass     = "Update Applicant Status">
<cfset CLIENT.actionType      = "Submit">
<cfset CLIENT.actionReference = "#CLIENT.AppNo#">
<cfset CLIENT.actionScript    = "">

<cfinclude template="../../control/RegisterAction.cfm">

<cfquery name="UpdateApplicant" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

UPDATE   Applicant 
SET      CandidateStatus    = '1'
WHERE    ApplicantNo        = '#CLIENT.AppNo#'
</cfquery>

<cflocation url="ApplicantDetail.cfm?ID=#URLEncodedFormat(CLIENT.AppNo)#" addtoken="No">		  
