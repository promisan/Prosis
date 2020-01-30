
<cfquery name="AllotmentAction"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM       ProgramAllotmentAction
	WHERE      ActionId = '#url.id#'
</cfquery>	

<cfif AllotmentAction.status eq "0">In process
<cfelseif AllotmentAction.status eq "1"><font color="green">Completed
<cfelseif AllotmentAction.status eq "9"><font color="FF0000">Cancelled</font>
</cfif>	