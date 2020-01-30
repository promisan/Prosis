
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    AssetItemObservation
		WHERE   ObservationId = '#url.Observationid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'AssObservation'
		AND    EntityStatus = '#get.ActionStatus#'
</cfquery>

<cfoutput>

	<cfif status.entitystatus eq "0"><font color="gray">
	<cfelseif status.entitystatus eq "9"><font color="red">
	</cfif>
	#Status.StatusDescription# on : <font color="408080">#dateformat(get.created,CLIENT.DateFormatShow)# #timeformat(get.created,"HH:MM")#
	
</cfoutput>	


