

<!--- pass true to geenrate the document --->

<cfset vCFR = "RapidResponse.cfr">

<cfquery name="getPeriod"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	ProgramPeriodReview
		WHERE 	ReviewId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfif getPeriod.Period gte 'F20'>
	<cfset vCFR = "../RapidResponse2/RapidResponse.cfr">
</cfif>

<cfreport 
	   template     = "#vCFR#" 
	   format       = "PDF" 
	   overwrite    = "yes" 
	   encryption   = "none"
	   filename     = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf">
			<cfreportparam name = "ID"  value="#Object.ObjectKeyValue4#"> 
	</cfreport>	