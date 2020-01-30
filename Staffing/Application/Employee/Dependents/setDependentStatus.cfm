
<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       PersonDependent
	    WHERE DependentId = '#url.id#'
	</cfquery>	
	
<cfif Check.actionStatus eq "9">
		<font color="FF0000"><cf_tl id="Superseded">	
	<cfelseif Check.actionstatus eq "0"><font color="green"><cf_tl id="Pending">
	<cfelseif Check.actionstatus eq "1"><font color="green"><cf_tl id="in Process">
	<cfelse> <cf_tl id="Cleared"></cfif>	
