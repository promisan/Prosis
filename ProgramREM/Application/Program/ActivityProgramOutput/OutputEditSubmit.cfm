<!---
17/11/03  commented out delete query that over wrote old outputs with new ones:  KRW
--->

<cfset dateValue = "">
<cfif #Form.ActivityOutputDate# neq ''>
    <CF_DateConvert Value="#Form.ActivityOutputDate#">
    <cfset DTE = #dateValue#>
<cfelse>
    <cfset DTE = 'NULL'>
</cfif>	


<TITLE>Submit Outputs</TITLE>

<cfquery name="Update" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
UPDATE ProgramActivityOutput  
SET    ActivityOutputDate = #DTE#,
	   ActivityPeriodSub = '#Form.SubPeriod#',
       Reference      = '#Form.Reference#',
	   OfficerUserId  = '#SESSION.acc#'
WHERE  OutputId = '#Form.OutputId#'
</cfquery>		

<cf_LanguageInput
	TableCode       = "ProgramActivityOutput" 
	Mode            = "Save"
	Name1           = "ActivityOutput"
	Key1Value       = "#Form.ProgramCode#"
	Key2Value       = "#Form.ActivityPeriod#"
	Key3Value       = "#Form.OutputId#">

<cflocation url="../ActivityProgram/ActivityView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.ActivityPeriod#" addtoken="No">		  

	

