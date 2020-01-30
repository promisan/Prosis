
<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request
		WHERE  Requestid = '#url.requestid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'wrkRequest'
		AND    EntityStatus = '#Request.ActionStatus#'
</cfquery>

<cfoutput>

    <cf_space spaces="40">
	<cfif status.entitystatus eq "0"><font color="gray">
	<cfelseif status.entitystatus eq "9"><font color="red">
	</cfif>
	#Status.StatusDescription# on : <b><font color="408080">#dateformat(request.created,CLIENT.DateFormatShow)# #timeformat(request.created,"HH:MM")#
	
</cfoutput>	


