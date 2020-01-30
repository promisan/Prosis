
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkorderBaseLine
		WHERE   TransactionId = '#url.transactionid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'WrkAgreement'
		AND    EntityStatus = '#get.ActionStatus#'
</cfquery>

<cfoutput>

	<cfif status.entitystatus eq "0">
	<font color="gray">
	<cfelseif status.entitystatus eq "9">
	<font color="red">
	</cfif>
	#Status.StatusDescription#
	
</cfoutput>	