
<!--- pass true to geenrate the document --->

<cfset vCFR = "../Project2/project.cfr">

<cfquery name="getPeriod"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	ProgramPeriodReview
		WHERE 	ReviewId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfquery name="getGroup"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	ProgramGroup
		WHERE 	ProgramCode = '#getPeriod.ProgramCode#'
</cfquery>

<cfif getGroup.ProgramGroup eq "D02">
	<cfset vCFR = "../RapidResponse/RapidResponse.cfr">
	<cfif getPeriod.Period gte 'F20'>
		<cfset vCFR = "../RapidResponse2/RapidResponse.cfr">
	</cfif>
</cfif>

<cfif getGroup.ProgramGroup eq "D03">
	<cfset vCFR = "project.cfr">
	<cfif getPeriod.Period gte 'F20'>
		<cfset vCFR = "../Project2/project.cfr">
	</cfif>
</cfif>

<cfreport 
	template     = "#vCFR#" 
	format       = "PDF" 
	overwrite    = "yes" 
	encryption   = "none"
	filename     = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf">
		<cfreportparam name = "ID"  value="#Object.ObjectKeyValue4#"> 
</cfreport>