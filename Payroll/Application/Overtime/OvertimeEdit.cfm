<cfparam name="URL.id" default="">
<cfparam name="URL.refer" default="">

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT  *
	FROM    PersonOvertime
	WHERE   1 = 1
	<cfif URL.id neq "">
	AND     PersonNo = '#url.id#'
	</cfif>	
	AND    OvertimeId = '#url.id1#'		
</cfquery>


<cfif check.TransactionType eq "Schedule"> 
	<cfinclude template="OvertimeEditSchedule.cfm">
<cfelse>
	<cfinclude template="OvertimeEditStandard.cfm">
</cfif>