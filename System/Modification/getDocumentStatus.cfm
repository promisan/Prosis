
<cfquery name="get" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#url.Observationid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'SysChange'
		AND    EntityStatus = '#get.ActionStatus#'
</cfquery>

<cfoutput>

	<cfif status.entitystatus eq "0"><font color="gray">
	<cfelseif status.entitystatus eq "9"><font color="red">
	</cfif>
	#Status.StatusDescription#: <font size="2" color="408080">#dateformat(get.created,CLIENT.DateFormatShow)# #timeformat(get.created,"HH:MM")#
	
</cfoutput>	


